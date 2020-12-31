Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A402E7F97
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 12:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgLaLLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 06:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgLaLLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Dec 2020 06:11:01 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B342C061573;
        Thu, 31 Dec 2020 03:10:21 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b73so17889130edf.13;
        Thu, 31 Dec 2020 03:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=60HjYK141PLVghL69p8+XiC3K0jS8dWaXg9nEjGfykU=;
        b=U5JSh17iW41gud9/X2N6Q2JCTVKEeOZhLuujxIry98El0393pJa9oDExiI3cYgAJS9
         vrqUqkN7GL59ZyvWNVURwS+o/shnsdUFVvflCoNzbD86lod0yeou/OwWBgrlmgZlv33q
         BlSHT106nrApJIKrBBWvEwSL+/z2d4GBPxIVPPZM4CjPmJrL5x9Mk4CoayCazhW9rFIY
         F+mp4wavarSa9k1Jo+QFTnfGzcr+AUQXbIpNlikhRTMOZqmXBs+MIdbPQC/51+BeEU/b
         5HGo5vGL/XCukEXn0MKqwguW5hNr3dC/OImuU+C6nubJKMKviihUldutLfpLY0iQQ4BM
         Efig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=60HjYK141PLVghL69p8+XiC3K0jS8dWaXg9nEjGfykU=;
        b=Thhn9PJApWxx4bWLLmqfEvNTrTJBXQdWa2gMXZlkHFsh6qWuvy9xrLsnUygXtzfWAC
         IavZeEqnAzdx67saKJK41Tfv7Chds+QE0HHBeaFVwiTvIn4Q0y8Jup0FIm6AWahekzLW
         dL0uekqstjJwpUfLutHAVIdjAFE0q1RXVX+s9KZFkU1UqXhR7PSyo/sIUri6yeQZZ52Q
         21G65PUHF08w8ngtzHSNtrPl/YW7LlOTrhxA+zIeLao2qJa9nzAFpJoZ02NIXvFVMPR7
         efICWNIRtSdRTi9LjDNYSCofHi0V5/W9uIHR51/FSG9f+jdhLTbxOWMYkz2AQM1SSXTw
         5Unw==
X-Gm-Message-State: AOAM5307rhZmH3rSVAzbq7I2Km9z/WXGnJuPGupPNbWiDN4TN//wrQ5Z
        bLGZrbuCMHdX9IPRJTjkddw=
X-Google-Smtp-Source: ABdhPJx8cEvHGjw33mi4NMWo90LdHK0QnEA1T1Snvds+5zqEgXCjEXrIVXTJpT7V1gZHRqU2015nyg==
X-Received: by 2002:a05:6402:2074:: with SMTP id bd20mr995961edb.326.1609413019751;
        Thu, 31 Dec 2020 03:10:19 -0800 (PST)
Received: from cl-fw-1.fritz.box (p200300d86714220053af1ffdd671ac4f.dip0.t-ipconnect.de. [2003:d8:6714:2200:53af:1ffd:d671:ac4f])
        by smtp.gmail.com with ESMTPSA id ch30sm39886535edb.8.2020.12.31.03.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Dec 2020 03:10:18 -0800 (PST)
Message-ID: <d6c5e253849a56b5b04ab4441c9dc0622d0083c7.camel@gmail.com>
Subject: Re: Haswell audio no longer working with new Catpt driver (was:
 sound)
From:   Christian Labisch <clnetbox@gmail.com>
To:     Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Greg Kroah-Hartman <stable@vger.kernel.org>,
        Greg Kroah-Hartman <linux-kernel@vger.kernel.org>,
        Akemi Yagi <toracat@elrepo.org>,
        Justin Forbes <jforbes@redhat.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Date:   Thu, 31 Dec 2020 12:10:17 +0100
In-Reply-To: <a194639e-f444-da95-095d-38e07e34f72f@metafoo.de>
References: <2f0acfa1330ca6b40bff564fd317c8029eb23453.camel@gmail.com>
         <efc6d5e8abc1da3cac754cb760fff08a1887013b.camel@gmail.com>
         <X+2MzJ7bKCQTRCd/@kroah.com>
         <a194639e-f444-da95-095d-38e07e34f72f@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lars-Peter,

Additional information to what I've sent you already before :
I found out that sound works with headphones (built-in audio)
But sound still does not work with speakers (built-in-audio).

Regards,
Christian

Christian Labisch
Red Hat Accelerator
clnetbox.blogspot.com
access.redhat.com/community
access.redhat.com/accelerators


On Thu, 2020-12-31 at 11:04 +0100, Lars-Peter Clausen wrote:
> On 12/31/20 9:33 AM, Greg Kroah-Hartman wrote:
> > On Wed, Dec 30, 2020 at 07:10:16PM +0100, Christian Labisch wrote:
> > > Update :
> > > 
> > > I've just tested the kernel 5.10.4 from ELRepo.
> > > Unfortunately nothing changed - still no sound.
> > Ah, sad.  Can you run 'git bisect' between 5.9 and 5.10 to determine the
> > commit that caused the problem?
> 
> The problem is that one driver was replaced with another driver. git 
> bisect wont really help to narrow down why the new driver does not work.
> 
> Christian can you run the alsa-info.sh[1] script on your system and send 
> back the result?
> 
> You say sound is not working, can you clarify that a bit? Is no sound 
> card registered? Is it registered but output stays silent?
> 
> - Lars
> 
> [1] https://www.alsa-project.org/wiki/AlsaInfo 
> <https://www.alsa-project.org/wiki/AlsaInfo>
> 
> 

