Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB8C600B91
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 11:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiJQJuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 05:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiJQJuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 05:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C29A5D712;
        Mon, 17 Oct 2022 02:50:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFBC360FEA;
        Mon, 17 Oct 2022 09:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD945C433C1;
        Mon, 17 Oct 2022 09:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666000198;
        bh=ErWcxx9nOoILXOyABR78DOXL8OkFXdvQG+byXYntWVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0yOpLg5m7IZDVglgkjPWQrhiaJITAe7hmAo2DQ+8v588CCUpGQVCQj/vublp7BFvA
         o+2XIIbPbzE6wSnsz2KcLAjTJqwhP/e5wsndbwblyIYGO0hWd65vhVi2Gv//p7fVr0
         B2eElVDl7fBwcJc3PookykEHFr8K5B4HxI8qGd5Y=
Date:   Mon, 17 Oct 2022 11:50:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Liu Zixian <liuzixian4@huawei.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH stable 5.10] mm: hugetlb: fix UAF in
 hugetlb_handle_userfault
Message-ID: <Y00ldZw++ubvPQtx@kroah.com>
References: <20221017093329.1538465-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017093329.1538465-1-liushixin2@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 05:33:29PM +0800, Liu Shixin wrote:
> commit 958f32ce832ba781ac20e11bb2d12a9352ea28fc upstream.

All backports now queued up, thanks.

greg k-h
