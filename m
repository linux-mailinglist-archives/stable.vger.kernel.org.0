Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E5B6D043C
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 14:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbjC3MBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 08:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjC3MBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 08:01:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACCE2D4F;
        Thu, 30 Mar 2023 05:01:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA3CF61FCE;
        Thu, 30 Mar 2023 12:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BA3C433D2;
        Thu, 30 Mar 2023 12:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680177702;
        bh=6ntgbqPsm33YH1sH0SLCxewnmtktXCJmfXXc0ll/uf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pCaLoEqoFZqqU5z+vh77bxb8OHc8LkrVd6Bhgaj69Gra9cR1jGAJfMup1KLuhp1zS
         do4iHVSKDuDJHFxzTudCp3+mBvUXq9oHvnC4aL5fMHDakyRYZ/PW/uGNAWGJQ7wxPJ
         F/J3yDUVoDIVzfaev3fvLqdKpwa/1c1cemSj9MhI=
Date:   Thu, 30 Mar 2023 14:01:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     stable@kernel.org, stable@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, boyu.mt@taobao.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        leejones@google.com, Ye Bin <yebin10@huawei.com>,
        syzbot+4faa160fa96bfba639f8@syzkaller.appspotmail.com,
        Jun Nie <jun.nie@linaro.org>
Subject: Re: [PATCH RESEND][for-stable 5.10, 5.4, 4.19, 4.14] ext4: fix
 kernel BUG in 'ext4_write_inline_data_end()'
Message-ID: <ZCV6I-CBHVw2GPre@kroah.com>
References: <20230307103840.2603092-1-tudor.ambarus@linaro.org>
 <42739df1-8b63-dfd6-6ec5-6c59d5d41dd8@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42739df1-8b63-dfd6-6ec5-6c59d5d41dd8@linaro.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 12:42:27PM +0100, Tudor Ambarus wrote:
> + stable@vger.kernel.org
> 
> Hi!
> 
> Can we queue this to Linux stable, please?

Queue what exactly?

confused,

greg k-h
