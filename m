Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920155FD6CE
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 11:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJMJQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 05:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiJMJPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 05:15:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F217632A9C
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D70861650
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E644C433C1;
        Thu, 13 Oct 2022 09:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665652492;
        bh=17oFUx1E2i2rhvkId5lCco3KdP2XNrQt8VP0KdVScvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vr4RnGrlNaYOuOhIkcnvs11hbIspEPc4GhfaccjhcgMY5iz1SL2oEbppbr6sxTit4
         OnDnDs0+7i5F7N29mQCh8QVYR+tRi8sMsRlZWwW+ke28BIcf8/zHQHC4UZWrotpJMC
         oa5MQTUl07ZXY2MrzyW/BRR88tbYon7XneOvo2Ec=
Date:   Thu, 13 Oct 2022 11:15:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     stable@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Venky Shankar <vshankar@redhat.com>
Subject: Re: ceph: don't truncate file in atomic_open
Message-ID: <Y0fXMR8twF2Lhu1m@kroah.com>
References: <59d7c10f-7419-971b-c13c-71865f897953@redhat.com>
 <20220701025227.21636-1-sehuww@mail.scut.edu.cn>
 <f87ea616-674b-2aad-f853-c28ea928ad4d@redhat.com>
 <ead853ef-172f-04e3-8a5b-ad5816b589a0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ead853ef-172f-04e3-8a5b-ad5816b589a0@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 11:30:06AM +0800, Xiubo Li wrote:
> Hi Maintainers:
> 
> This is one very important bug fixing patch needed to be backported for
> ceph.
> 
> I have attached the patches based one the latest branches[1] of 4.9.y,
> 4.14.y, 4.19.y, 5.4.y, 5.10.y, 5.15.y and 5.19.y.
> 
> This patch is simple and the conflict is trivial.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git

Ah, missed this, thanks, now queued up.

greg k-h
