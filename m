Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F9A657A8C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiL1PNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiL1PMh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:12:37 -0500
X-Greylist: delayed 545 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Dec 2022 07:12:06 PST
Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77B513EA0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:11:58 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5ddd79e3.dip0.t-ipconnect.de [93.221.121.227])
        by mail.itouring.de (Postfix) with ESMTPSA id 09330127843;
        Wed, 28 Dec 2022 16:02:58 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id A7B41EEB614;
        Wed, 28 Dec 2022 16:02:57 +0100 (CET)
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
References: <20221228144330.180012208@linuxfoundation.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <2bf086f8-aa9d-b576-ba8b-1fcfbc9a4ff1@applied-asynchrony.com>
Date:   Wed, 28 Dec 2022 16:02:57 +0100
MIME-Version: 1.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-12-28 15:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I know this is already a large set of updates, but it would be great if
commit 6f12be792fde994ed934168f93c2a0d2a0cf0bc5 ("mm, mremap: fix mremap()
expanding vma with addr inside vma") could be added as well; it applies and
works fine on top of 6.1.1.
This fixes quite a few annoying mmap-related out-of-memory failures.

cheers
Holger
