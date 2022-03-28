Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409C14E95B2
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbiC1LwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242891AbiC1Lun (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:50:43 -0400
Received: from relay5.hostedemail.com (relay5.hostedemail.com [64.99.140.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F38C29C9D
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 04:44:53 -0700 (PDT)
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D4C723546;
        Mon, 28 Mar 2022 11:44:52 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id CCBAC20031;
        Mon, 28 Mar 2022 11:44:45 +0000 (UTC)
Message-ID: <d22ab1b8a17220fc8a5de94be037138a7a043ace.camel@perches.com>
Subject: Re: [PATCH AUTOSEL 4.19 02/12] loop: use sysfs_emit() in the sysfs
 xxx show()
From:   Joe Perches <joe@perches.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Date:   Mon, 28 Mar 2022 04:44:44 -0700
In-Reply-To: <20220328112417.1556946-2-sashal@kernel.org>
References: <20220328112417.1556946-1-sashal@kernel.org>
         <20220328112417.1556946-2-sashal@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Stat-Signature: obmf73rx3tnfzbozg4wnjhp4k17hbdr4
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: CCBAC20031
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/l3C74hzmVuV7AIL7xJJu0gQ8RzTgtr1k=
X-HE-Tag: 1648467885-922355
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-03-28 at 07:24 -0400, Sasha Levin wrote:
> From: Chaitanya Kulkarni <kch@nvidia.com>
> 
> [ Upstream commit b27824d31f09ea7b4a6ba2c1b18bd328df3e8bed ]
> 
> sprintf does not know the PAGE_SIZE maximum of the temporary buffer
> used for outputting sysfs content and it's possible to overrun the
> PAGE_SIZE buffer length.

IMOP This isn't something that should be backported.


