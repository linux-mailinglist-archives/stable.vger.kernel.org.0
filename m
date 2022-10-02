Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B465F23E4
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 17:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiJBPey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 11:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiJBPeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 11:34:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8128F
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 08:34:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8B1860EAC
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 15:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9BDC433D6;
        Sun,  2 Oct 2022 15:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664724887;
        bh=o/FhibU/i2+Ktxo9AK8F5fvI+wbeoO76ik6XVhoou1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DvzyPo3Iw5FbjPSBDyTrDfJjFOkRS/7EK0Bj85bYIZBIn8O6TN5M+SPeiNdc8gIva
         vnWEahUXpirQrLpeTcujvU5KqoeIrR26UXf43aP/qKzkJPmM7VsQIJ3nIAg4VUn7At
         SnXdCLMfZkf4g0ZF6oRmaVonIRSMgex23IghDkec=
Date:   Sun, 2 Oct 2022 17:35:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     gouhao@uniontech.com
Cc:     stable@vger.kernel.org, tyhicks@linux.microsoft.com,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        jmorris@namei.org, serge@hallyn.com
Subject: Re: [PATCH 0/3] Backporting some memory leak of ima policy to 4.19+
 from mainline
Message-ID: <YzmvvJx1fMOD6SMY@kroah.com>
References: <20220930074937.23339-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930074937.23339-1-gouhao@uniontech.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 30, 2022 at 03:49:34PM +0800, gouhao@uniontech.com wrote:
> From: Gou Hao <gouhao@uniontech.com>
> 
> patch1: is memory leak of audit rule
> patch2~3: is memory leak about 'fsname' field of struct ima_rule_entry
> 
> Tyler Hicks (3):
>   ima: Have the LSM free its audit rule
>   ima: Free the entire rule when deleting a list of rules
>   ima: Free the entire rule if it fails to parse
> 
>  security/integrity/ima/ima.h        |  5 +++++
>  security/integrity/ima/ima_policy.c | 24 ++++++++++++++++++------
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> -- 
> 2.20.1
> 

Now queued up, thanks.

greg k-h
