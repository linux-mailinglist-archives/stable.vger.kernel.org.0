Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A105FD6AD
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 11:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiJMJLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 05:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJMJLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 05:11:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01402107CC9
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:11:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88CF8B819F4
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE9DC433C1;
        Thu, 13 Oct 2022 09:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665652289;
        bh=68TrkEl6LmaU1An+vRo42jaoNkVltbD2RAbiU7ggGno=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PBFHTGFE4qCFdo5OYc9U3r2Nic/4LMpxAMEyt730+gGPEbAJSqINmG8uCP+eIr1M3
         +ceVawpC18Zsze8XnKvlNzwYrRMx/3GS+MPZ8JcHm2FnekllTlx06RuJmCdGmnCI6b
         pGVb2JIacL7mhaE4wQ2tE7KONTT1OfVwSczSb41A=
Date:   Thu, 13 Oct 2022 11:12:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: ceph: don't truncate file in atomic_open
Message-ID: <Y0fWbKksISUWcCeA@kroah.com>
References: <59d7c10f-7419-971b-c13c-71865f897953@redhat.com>
 <20220701025227.21636-1-sehuww@mail.scut.edu.cn>
 <f87ea616-674b-2aad-f853-c28ea928ad4d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f87ea616-674b-2aad-f853-c28ea928ad4d@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 09:51:43AM +0800, Xiubo Li wrote:
> Hi Maitainers
> 
> This patch is a fix in kceph module and should be backported to any affected
> stable old kernels. And the original patch missed tagging stable and got
> merged already months ago:

Does not apply to the trees, sorry.  Please provide a working backport
if you wish to see it applied.

thanks,

greg k-h
