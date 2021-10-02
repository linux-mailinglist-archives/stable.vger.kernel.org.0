Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DF241FDCC
	for <lists+stable@lfdr.de>; Sat,  2 Oct 2021 20:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhJBSw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Oct 2021 14:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbhJBSw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Oct 2021 14:52:56 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EFEC0613EC
        for <stable@vger.kernel.org>; Sat,  2 Oct 2021 11:51:10 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x7so46145261edd.6
        for <stable@vger.kernel.org>; Sat, 02 Oct 2021 11:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KdP4fI8E/dFqBPvw71gyuqgU8AZ1mfgWR9mHj59NkDM=;
        b=AklDwk7alvTtOiFLPDozGr5kC0ezDkoBwBElCt78HizsL9IS2I3D86FngvrvG5y0jU
         t1wbRPt5zmeA0U9AW8EKiJBr7V4CvNCnhzQbEx+XrlkbOL4ppUT3LFIp4a79InFJPjWQ
         fiUGxfyP54zzs6l8CTwxsCDfsmflwXn6WjIJOefQmfPnInLtIYWe8CItMvBZqDif1Vvr
         +0q/3V9i2FxBzhAq2w3Amcgiunr89SB/1L5lng5eNY9q4m64uF9On6hsiNFm2LP8K+Iw
         6bLrGnWyd1cUtTgQn4/T9yALoSvwNtogfNQ0QfrLjZWRc19MavjxcW0O//QlScWu0LiK
         byiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=KdP4fI8E/dFqBPvw71gyuqgU8AZ1mfgWR9mHj59NkDM=;
        b=N80cRU+83oxfHyRQtW1vuB74QGITuPgDB0JJUFzM6EmPNEEgYn+JuU2cDUTfeWtqGg
         TNP1TjaRTF+Fslrb1KuMFZ2vc1WGnTJ33gF997MjbmeU97l3F6Kwsuo2mmdhMIe8j4R5
         9crbmZ/EJWCX/l8WsK95NRpw+9zrZ+VPeOLQ8WP2r0fVKTuy3oLxO2XjMeAzJbB7rNJ4
         v/zx4IB15ZhtOlda3eOcfUizvgZgMuJF/7bm4SkctETFxOsiZOLyCzvyIJw/MzWI4T5J
         hHIJzxz9gCFRBmwoGKJIdUtLQE7r8pKXg+Yihk0GNKyXZD4zlSQfDSQODJfpeh1vrqfl
         ZMKA==
X-Gm-Message-State: AOAM533E+oq2pkVOXnLbZxhNzU97I3iUNQcXQ/wpnjvnuqayaKK5l3RS
        tK8mBxxhu/NrwnHcMI3IOV/ytjtzzBfwiw==
X-Google-Smtp-Source: ABdhPJxBfZk0HnJwsBm4Ifm5IFK2Y/Q9+J7sULVkxCXcXTqInFwDBNIl36wpDWd3D7GUBbeY9RKO8A==
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr5541023edb.383.1633200668601;
        Sat, 02 Oct 2021 11:51:08 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id t4sm4874655edc.2.2021.10.02.11.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 11:51:07 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 2 Oct 2021 20:51:07 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        greg@kroah.com
Subject: Re: [PATCH 5.4 0/3] usb: hso: backport CVE-2021-37159 fix
Message-ID: <YViqG5Yun6N7bhVl@eldamar.lan>
References: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
 <YVNs/mLb9YXNz7G+@eldamar.lan>
 <2c3095ae-9f67-2a38-e258-1f8d707c4fa2@windriver.com>
 <YVc9mtE329rqf5ab@sashalap>
 <18e2816e-cf21-27c2-afc6-bc46fcebde88@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18e2816e-cf21-27c2-afc6-bc46fcebde88@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Oct 02, 2021 at 03:36:21PM +0300, Ovidiu Panait wrote:
> Hi Sasha,
> 
> On 10/1/21 7:55 PM, Sasha Levin wrote:
> > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > 
> > On Wed, Sep 29, 2021 at 11:03:19AM +0300, Ovidiu Panait wrote:
> > > Hi Salvatore,
> > > 
> > > On 9/28/21 10:29 PM, Salvatore Bonaccorso wrote:
> > > > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > > > 
> > > > Hi Ovidiu
> > > > 
> > > > On Tue, Sep 28, 2021 at 04:15:20PM +0300, Ovidiu Panait wrote:
> > > > > All 3 upstream commits apply cleanly:
> > > > >    * 5fcfb6d0bfcd ("hso: fix bailout in error case of
> > > > > probe") is a support
> > > > >      patch needed for context
> > > > >    * a6ecfb39ba9d ("usb: hso: fix error handling code of
> > > > > hso_create_net_device")
> > > > >      is the actual fix
> > > > >    * dcb713d53e2e ("usb: hso: remove the bailout parameter")
> > > > > is a follow up
> > > > >      cleanup commit
> > > > > 
> > > > > Dongliang Mu (2):
> > > > >   usb: hso: fix error handling code of hso_create_net_device
> > > > >   usb: hso: remove the bailout parameter
> > > > > 
> > > > > Oliver Neukum (1):
> > > > >   hso: fix bailout in error case of probe
> > > > > 
> > > > >  drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
> > > > >  1 file changed, 23 insertions(+), 10 deletions(-)
> > > > Noticing you sent this patch series for 4.14, 4.19 and 5.4 but am I
> > > > right that the last commit dcb713d53e2e ("usb: hso: remove the bailout
> > > > parameter") as cleanup commit should ideally as well be applied to
> > > > 5.10.y and 5.14.y?
> > > > 
> > > > Whilst it's probably not strictly needed it would otherwise leave the
> > > > upper 5.10.y and 5.14.y inconsistent with those where these series are
> > > > applied.
> > > 
> > > You're right, I have sent the cleanup patch for 5.10/5.14 integration
> > > as well:
> > > 
> > > https://lore.kernel.org/stable/20210929075940.1961832-1-ovidiu.panait@windriver.com/T/#t
> > > 
> > 
> > Why do we need that cleanup commit in <=5.4 to begin with? Does it
> > actually fix anything?
> > 
> The cleanup patch was part of the same patchset with a6ecfb39ba9d ("usb:
> hso: fix error handling code of hso_create_net_device") fix .
> 
> 
> I think it can be dropped, as it doesn't seem to fix anything. Can only the
> first two commits be cherry-picked for <=5.4, or should I resend?

Probably the right thing to do, Sasha and Ovidiu. Picking it would
have the small advantage of future commits to backport which would
conflict around the changed lines.

But I have no voice on that matter, I was really only going thorugh
some stable commits backports request covering CVEs and noticed the
submission and it's discrepancy.

For Debian I have for now picked all three commits on top of 4.19.208.

Regards,
Salvatore
