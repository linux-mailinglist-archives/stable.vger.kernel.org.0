Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270CD45A29F
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 13:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbhKWMdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 07:33:22 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57881 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236687AbhKWMdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 07:33:22 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 42C6B5C025E;
        Tue, 23 Nov 2021 07:30:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 23 Nov 2021 07:30:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=+EZDlGXdbDtH/vqFYKb48nYolhR
        FQjQrsIqjWtvnJAo=; b=SzJyE3mLiuSib3RTyDKKAVeifQ1q9SwlAe1fjoR2Key
        bvGQ/f/AxhMAd1RJdVaX2JKwU+ECO/Vj2cI0jXbB6ajAtswpSNyRRZeUaVZPqOlk
        MjoJbsmhuGBDE9X8kcV5H3UEofdYLnq/Tfqrfr1c53jlHo6AP7ps8q+TYZSXmjH/
        ooK5lpfLQzJvdhviCzBRFed1EL6Nz3jkwgeVaXD0M6Ngk+R/lGdc7cBjmpDD9IgF
        U0gtbyGgpih93s1pFyOYOSRQUO1Y6hmhnQSocLWH6XuLfKOlXYbv9EFq3oyIFUac
        /hWXZig/vXwB9RbYsC9oCpw/tdMyYfD1X0A2cwqrhjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+EZDlG
        XdbDtH/vqFYKb48nYolhRFQjQrsIqjWtvnJAo=; b=HIBCiSRaEjpe6DlH50y5YX
        JKlNzpYHfc62sEhwdfnZh3YtUXwm0YYYQcEmzKK0InakMtg584X7rgHrmsXbDjP4
        dhfdyLWxzeZF7rJldkDGcLn6kL0bbQO9PcDk8n+U4jUDpzZ7ezRTW5Jp8SBV5/j+
        rU4f+riZLM/+AxPdAXnYhTHKOiHtz+3j8CQqzy8djRLG0d1lH/P40weQyNpJHXOR
        a6D8UNr/oumZbAzDRmf0Tlm+2sfJXaTzjtlTshvYBWIi0do54cSGApdd/09NDW3v
        mV9VcY3SVKfU92hTg/CgMuoCp1P2MgfHftlw3rjySaXj9INBvKg4YJUB6kd18t0w
        ==
X-ME-Sender: <xms:1d6cYbAKgE-ZU3949ner31IimjQE5sgRfsqdocGodDVgddTjcLWnpA>
    <xme:1d6cYRjJVKXPMe4fvL2aQwxIgY66oOaQ9_NJEoDPvFsySlAtNv4PNw8EmCkxzpsEO
    hZnioEIE-tnSg>
X-ME-Received: <xmr:1d6cYWmHRbtY8VSt7XkOltmDNZINmEwwBGVassU1JmDfACzX-HwOGlk20JGnKBY0kfRHuWATSmPj4jkFxNVeSpgb0sKykSOU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigdegtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:1t6cYdxp8lsFQMiwoKQUoQfTpM8S5hJ5gFnmQ4TngqcRdDFI6p8KhA>
    <xmx:1t6cYQR_ZoxNjjRjcMiAhQRbiiKTL_2_IALlzERDD05-xIAWSV8hmg>
    <xmx:1t6cYQZJWO6CzuTTWHT0gl18EzOa7OhqyQQVhhj_SD2QgqHgAtAHOA>
    <xmx:1t6cYfF7xbKLpyjNNilyjRKSsW-1cMZVW8ica6LNRx7bu4nDba3GMg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 07:30:13 -0500 (EST)
Date:   Tue, 23 Nov 2021 13:30:11 +0100
From:   Greg KH <greg@kroah.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 5.10 0/2] scsi: ufs: core: Fix task management completion
Message-ID: <YZze04KBEL1IckWI@kroah.com>
References: <20211123121930.1464738-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123121930.1464738-1-adrian.hunter@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 02:19:28PM +0200, Adrian Hunter wrote:
> Hi
> 
> Here are 2 patches backported for v5.10.  Upstream there is a third patch
> associated with these i.e. commit 5cb37a26355 ("scsi: ufs: core: Fix
> another task management completion race"), but it is not needed because
> v5.10 has different lock usage.
> 
> 
> Adrian Hunter (2):
>       scsi: ufs: core: Fix task management completion
>       scsi: ufs: core: Fix task management completion timeout race
> 
>  drivers/scsi/ufs/ufshcd.c | 57 +++++++++++++++++++----------------------------
>  drivers/scsi/ufs/ufshcd.h |  1 +
>  2 files changed, 24 insertions(+), 34 deletions(-)
> 

Both now queued up, thanks.

greg k-h
