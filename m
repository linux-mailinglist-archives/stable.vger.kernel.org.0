Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC981647E58
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 08:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLIHM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 02:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLIHM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 02:12:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4136A178A4;
        Thu,  8 Dec 2022 23:12:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E082B827C0;
        Fri,  9 Dec 2022 07:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA10C433D2;
        Fri,  9 Dec 2022 07:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670569972;
        bh=B8X1Ucx02xVAZUzjV3GymTkK+BIhfwtMyQOBPQPdNQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pg07lEauvbO+vNc+3ufhE+J4vTUVVSvZVtWKvjfeL7U9kHS4CLWFDg7jBc4svkXeR
         TJt4A/UXgPivc/Mhojtek0t8ySz5y772ZqLkCHrpuWoGvJWLaAU6A4jd/x4cXmOkZK
         7qtAVqkUjbcI6bJ5SwWPZWHkuqYW6/qB+fcP/Mag=
Date:   Fri, 9 Dec 2022 08:12:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
        Paul Moore <paul@paul-moore.com>, sds@tycho.nsa.gov,
        eparis@parisplace.org, sashal@kernel.org, selinux@vger.kernel.org,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [RFC] IMA LSM based rule race condition issue on 4.19 LTS
Message-ID: <Y5Lf8SRgyrqDJwiH@kroah.com>
References: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 09, 2022 at 03:00:35PM +0800, Guozihua (Scott) wrote:
> Hi community.
> 
> Previously our team reported a race condition in IMA relates to LSM based
> rules which would case IMA to match files that should be filtered out under
> normal condition. The issue was originally analyzed and fixed on mainstream.
> The patch and the discussion could be found here:
> https://lore.kernel.org/all/20220921125804.59490-1-guozihua@huawei.com/
> 
> After that, we did a regression test on 4.19 LTS and the same issue arises.
> Further analysis reveled that the issue is from a completely different
> cause.

What commit in the tree fixed this in newer kernels?  Why can't we just
backport that one to 4.19.y as well?

thanks,

greg k-h
