Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC555F7D6A
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 20:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJGScK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 14:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJGScJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 14:32:09 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38FEE3BC59
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 11:32:09 -0700 (PDT)
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6243720EA2BD;
        Fri,  7 Oct 2022 11:32:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6243720EA2BD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1665167528;
        bh=zLkIarYv/xL0dDzL28dffs/b6bdKkqAkc9mTJmKArlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YrqtvJQ/7225ZODj6JVlm4ymz9NxXIw7pAfBMsSPXq5VkyOY8w+e77sUNmYvTFiCl
         gnsrTZQakb3TFzRiB0j0oqD/3NkiFRNYkvABQUXMBa5KF7T8FW0hK36EFUs9nBmP+U
         sSGD3NvpYZplqAupuD7nlzK+J54qUc6wcMqRHyG8=
Date:   Fri, 7 Oct 2022 13:31:45 -0500
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     gouhao@uniontech.com, stable@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        jmorris@namei.org, serge@hallyn.com
Subject: Re: [PATCH 0/3] Backporting some memory leak of ima policy to 4.19+
 from mainline
Message-ID: <Y0BwkcMaWnuqOXLI@sequoia>
References: <20220930074937.23339-1-gouhao@uniontech.com>
 <YzmvvJx1fMOD6SMY@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzmvvJx1fMOD6SMY@kroah.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-02 17:35:24, Greg KH wrote:
> On Fri, Sep 30, 2022 at 03:49:34PM +0800, gouhao@uniontech.com wrote:
> > From: Gou Hao <gouhao@uniontech.com>
> > 
> > patch1: is memory leak of audit rule
> > patch2~3: is memory leak about 'fsname' field of struct ima_rule_entry
> > 
> > Tyler Hicks (3):
> >   ima: Have the LSM free its audit rule
> >   ima: Free the entire rule when deleting a list of rules
> >   ima: Free the entire rule if it fails to parse
> > 
> >  security/integrity/ima/ima.h        |  5 +++++
> >  security/integrity/ima/ima_policy.c | 24 ++++++++++++++++++------
> >  2 files changed, 23 insertions(+), 6 deletions(-)
> > 
> > -- 
> > 2.20.1
> > 
> 
> Now queued up, thanks.

I know these patches have been already applied and were even released a
couple days ago but I wanted to say that I reviewed these backports,
since they were a little tricky, and they all look good. Thanks for
doing this, Gou!

Tyler

> 
> greg k-h
> 
