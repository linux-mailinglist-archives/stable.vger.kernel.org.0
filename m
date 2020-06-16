Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3B01FB0AF
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 14:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgFPM34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 08:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgFPM3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 08:29:55 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA099C08C5C2
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 05:29:55 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v24so8325139plo.6
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 05:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vcJeF2JaqC4iu/GRBmwyDJKlIhIk436bSUtDZgPmAEk=;
        b=dOB7+dFfzhYAwQPQ1yjxeBcMnp9etPaDNVs8C7cMV7+PYsHPBPdtOehtZVisn+Zmhi
         lx/cOAEYdq5p7UBAYsmON9BozL9lqteu87Py4Hjb8NB7Weno2vUpAHqPSdW6PU6sjQeB
         FSSyHbqHqXHRX2OgVh3pYTPwF8ZkDCjsZ7eamCw9o+E4K7MYXkea+Nll1BUyzi79JkR2
         ryekDJYOijAfx5i4CieDNyyFmA4QlbyzH5X6BvJnfYBB/oO2mnbw26VPPDuLUjn83HkO
         0tnIeOM1ggH6ogzIpHtGfeaRvfVmqMaOMf9NHplV8SOBLrZ7is0yt9/WVHi7q5vHcn+H
         /c9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vcJeF2JaqC4iu/GRBmwyDJKlIhIk436bSUtDZgPmAEk=;
        b=P4uHcagvlTbfmsUz67qNgA3DsD2pLrys5qBssBABSUYNRSTnETFCznCkDmbN/czi64
         BRCANG57yUHcR3+Yw/S+JRJ+amJrDUJ30wivmL2bfLAnQ8QMtg4ZQmanrzwHrzRZKI5y
         gzcKR+8WwF1xqmwQpeAMEgnVWD3Y19IK2ydCmz8F5h4NE0BJ+JtCMfDdGw3Hu6X3cy3Z
         t/cPXhq9/G9PzseHt/ucr3s548lLLZ0HHCSmStEbZBfpa5EoohpjinGkQQ8JOBwcXfAG
         SAbtfEDXNHY+6Jvsc57z0Abb5pug3zCNa2xwR3ODwM60rHuiwRVs6hcx6Nhy0gCNKER8
         v5XQ==
X-Gm-Message-State: AOAM532QBgNCaONt45cuIQqbkcLx60EdzHN2K2UHtTOOL0dA/TRyiWt1
        HCSriRnRZM4Me/m3kyZmCms=
X-Google-Smtp-Source: ABdhPJxBnqRpS33wCGuruw/JiwXCQue+vIafrulRZxjkqPf70tCcEoXQi6z5Gw7k4IT6e6/MGQRyIw==
X-Received: by 2002:a17:902:7297:: with SMTP id d23mr1989963pll.35.1592310595068;
        Tue, 16 Jun 2020 05:29:55 -0700 (PDT)
Received: from taihen.jp ([2405:6580:2100:d00:e039:f876:9cfb:e6bd])
        by smtp.gmail.com with ESMTPSA id c12sm14769583pgt.91.2020.06.16.05.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 05:29:54 -0700 (PDT)
Date:   Tue, 16 Jun 2020 21:30:31 +0900
From:   Mattia Dongili <malattia@linux.it>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: sony-laptop fix for 5.6 and 5.7
Message-ID: <20200616123031.GA5705@taihen.jp>
References: <20200607035055.GA8646@taihen.jp>
 <20200616121601.GC3542686@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616121601.GC3542686@kroah.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 5.7.0-rc4+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 02:16:01PM +0200, Greg KH wrote:
> On Sun, Jun 07, 2020 at 12:50:55PM +0900, Mattia Dongili wrote:
> > commit 95e2c5b0fd6d7a022f37e7c762ea093aba7b8e34 upstream
> 
> I do not see that commit id in Linus's tree.  Are you sure it is
> correct?

Heh, no. I didn't rebase my local tree... rookie mistake.
It should be 47828d22539f76c8c9dcf2a55f18ea3a8039d8ef.

I noticed that Sasha Levin autoselected for 5.7 both the patches for
sony-laptop related to the ACPI breakage.
So they are only missing in 5.6 at this point and it's worth getting
both even though only 47828d22539f should be sufficient.

The two commit ids that were picked up for 5.7 are:

[ Upstream commit 47828d22539f76c8c9dcf2a55f18ea3a8039d8ef ]
[ Upstream commit 476d60b1b4c8a2b14a53ef9b772058f35e604661 ]

Thanks
-- 
mattia
:wq!
