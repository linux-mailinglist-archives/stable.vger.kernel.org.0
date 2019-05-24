Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4552976B
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 13:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390803AbfEXLjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 07:39:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40391 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390743AbfEXLjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 07:39:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AE0AE217DD;
        Fri, 24 May 2019 07:39:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 24 May 2019 07:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=c
        xc1X/eKnqiizZKLiHlKXcwi1Gxurf/gmXT0A2WbKuQ=; b=YFTZMAQmuUYTd2vG8
        E6ROhsJFIKGvQa5ptuKrT/wDdYuQsCjKsj9TZlArm9qJ5+ueQD8Es8dOT87VD34L
        3aTs/G+vzLxw5hzVtQJYYI9VcSyIGqOTwGCKDYTj0gYsguMD1YlVxriz6HumJf4J
        hbC8jqMjEsIGrlIzjMSagtvpxOLDlzXM6uodjkL55BQ4waoKyNsdh3n5xf391+fK
        qHy8gh3ZvHwJyzw2+9tW54kcy9qsZRHlRkLIL0xV0jjR/5mQhfyJYsmB/HIiXmLU
        GqyshhDt3BrHS5DdtUdLkUoRMrq2lJaFJMPsdzUh3tYX+hNhGjAp8nmQnjJ+3x6d
        0Rkpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=cxc1X/eKnqiizZKLiHlKXcwi1Gxurf/gmXT0A2WbK
        uQ=; b=q4HiGO7vdIVX2I5qxX/SvTLtyMaZx9Bwb078Bns8Gvc4PgyACzThFebyX
        ZRkaGPvE3VDtJbPblryWjV0ibxKSunBh3BHEVhkifoVIuwdUaxtm9ORMmoJ6CWvY
        0BIvbshE0dSkys22i3EeWYqk0OfTGPiUcU/nXgd+7N+2++prSy+S1G6ZVuazuv9t
        KShPLXKSoyqJ85TP9tVWySdVYb3lHG7c9AGDc2CCnhI8lxjNACsUT3bb2RDDeaPB
        Z1HkrmNj+L+obu2RZII+E08VWg4P86Q2u6uhw296xoH6MOX+OKXyo7pttxd4cC6V
        4zil/3uevmuWmCVDZo7okGVrwlK3A==
X-ME-Sender: <xms:6tfnXFKCLzAnRxIZudmvtCN-Lmq9MlwQ7aaiMNM4sx33IBa9KlO18Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudduiedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvg
    hlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6tfnXBWukTvNHQ86hJLNPcIK7Dl6bOIkJIn9_LvNUJgE7XERMuOA6A>
    <xmx:6tfnXHNmaR1MIBFYk8nrhVmLhvlv5sO9lsVWaRGU3zBtP6oq8xfPEw>
    <xmx:6tfnXFemx5nqJLD5aKi7NGmk_sxjoX3d-qnv9Ck36HVpJXP3IVhqWg>
    <xmx:6tfnXIRJc4Y6JjKvB-M74gplIKuOiITr3GKDnMuylbu4Ilj4L3jj8g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B53B98005A;
        Fri, 24 May 2019 07:39:21 -0400 (EDT)
Date:   Fri, 24 May 2019 13:39:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     Takashi Iwai <tiwai@suse.de>, stable@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: [PATCH] Revert "ALSA: hda - Enforces runtime_resume after S3 and
 S4 for each codec"
Message-ID: <20190524113918.GB32272@kroah.com>
References: <20190524051015.4680-1-jian-hong@endlessm.com>
 <s5h7eagflv5.wl-tiwai@suse.de>
 <CAPpJ_eepxOZ4FBERLb0z=PpVgHcxD3+duRFqXbnQjrW48MTnDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPpJ_eepxOZ4FBERLb0z=PpVgHcxD3+duRFqXbnQjrW48MTnDQ@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 05:40:03PM +0800, Jian-Hong Pan wrote:
> Takashi Iwai <tiwai@suse.de> 於 2019年5月24日 週五 下午1:43寫道：
> >
> > On Fri, 24 May 2019 07:10:17 +0200,
> > Jian-Hong Pan wrote:
> > >
> > > We have an ASUS E406MA laptop equipped with Intel N5000 CPU.  After
> > > system suspend & resume, the audio playback does not work anymore. The
> > > device for sound output is listed as a headphone device.  Plugging in
> > > headphones no sound is audible neither.
> > >
> > > Here are the error messages after resume:
> > >
> > > [  184.525681] snd_hda_intel 0000:00:0e.0: azx_get_response timeout, switching to polling mode: last cmd=0x20bf8100
> > > [  185.528682] snd_hda_intel 0000:00:0e.0: No response from codec, disabling MSI: last cmd=0x20bf8100
> > > [  186.532683] snd_hda_intel 0000:00:0e.0: azx_get_response timeout, switching to single_cmd mode: last cmd=0x20bf8100
> > > [  186.736838] snd_hda_codec_realtek hdaudioC0D0: Unable to sync register 0x2b8000. -5
> > > [  186.738742] snd_hda_codec_realtek hdaudioC0D0: Unable to sync register 0x2b8000. -5
> > > [  186.767080] snd_hda_codec_hdmi hdaudioC0D2: Unable to sync register 0x2f0d00. -5
> > >
> > > After bisect, we found reverting the commit b5a236c175b0 "ALSA: hda -
> > > Enforces runtime_resume after S3 and S4 for each codec" can solve this
> > > issue on Linux stable 5.0.x series.
> > >
> > > This reverts commit a57af6d07512716b78f1a32d9426bcdf6aafc50c.
> > >
> > > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=203623
> > > Fixes: a57af6d07512 ("ALSA: hda - Enforces runtime_resume after S3 and S4 for each codec")
> > > Cc: <stable@vger.kernel.org> # 5.0.x
> > > Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> >
> > I thought this revert isn't needed if the i915 GLK fix is applied?
> 
> If the i915 GLK fix is applied, then this revert is not needed.
> 
> I have also sent the "i915 GLK" to stable mail list for Linux stable
> 5.1.x.  But I am still wondering for 5.0.x, due to the commit
> dependency.
> Any idea for Linux stable 5.0.x will be appreciated.

5.0.x will be end-of-life by the end of next week, don't worry about it
too much :)

thanks,

greg k-h
