Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC2331E6ED
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 08:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhBRH1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 02:27:12 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:20978 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbhBRHVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 02:21:00 -0500
Received: from localhost (pvp1.blr.asicdesigners.com [10.193.80.26])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 11I7JGde030535;
        Wed, 17 Feb 2021 23:19:17 -0800
Date:   Thu, 18 Feb 2021 12:49:16 +0530
From:   Krishnamraju Eraparaju <krishna2@chelsio.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, krishna2@chelsio.com,
        bharat@chelsio.com
Subject: backport of IB/isert commit to '5.10.y' stable release
Message-ID: <20210218071914.GA17349@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Greg,

Could you please backport the below commit to "5.10.y" stable release.

Looks like this commit was already pulled to "5.10.y" stable tree weeks
ago.

This fix is required for Chelsio adapters. Without this fix the number
of connections supported by isert(over Chelsio adapter) will be significantly less.

--------------------------------------------------------
commit ID: dae7a75f1f19bffb579daf148f8d8addd2726772
IB/isert: add module param to set sg_tablesize for IO cmd
Author: Max Gurtovoy <mgurtovoy@nvidia.com>
Fixes: 317000b ("IB/isert: allocate RW ctxs according to max IO size")


Thanks,
Krishnamraju.

