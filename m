Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC7F4D526A
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237930AbiCJT1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 14:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237730AbiCJT1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 14:27:09 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6748F137029;
        Thu, 10 Mar 2022 11:26:08 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 87F8168AFE; Thu, 10 Mar 2022 20:26:04 +0100 (CET)
Date:   Thu, 10 Mar 2022 20:26:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Subject: Re: [BUG] new MIPS compile error on v5.15.27
Message-ID: <20220310192604.GA7526@lst.de>
References: <D148EFBD-55E0-449A-AD2A-12C80ABD4FC4@goldelico.com> <YipL4KYG0hXa0g2s@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YipL4KYG0hXa0g2s@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 08:05:04PM +0100, Greg KH wrote:
> Thanks for the report.  I'll work on resolving this for the next round
> of stable releases _after_ the ones that are currently out for review
> are released.

If you think the genhd.h include cleanup is the best fix feel free
to pick it up.  But I really think it is just hiding the problem,
and that problem will resurface.
