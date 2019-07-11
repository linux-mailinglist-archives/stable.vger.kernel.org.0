Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2433651EF
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 08:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfGKGnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 02:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfGKGnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 02:43:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6B7F20838;
        Thu, 11 Jul 2019 06:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562827388;
        bh=PbD+vmI4bolEzqXxV3CbUbl9K6yA4WOQJXUIUJn9wpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zBxJvMzckpLQjJBAtUURZbYk9Uk2Zi8u1iTyFBrbw30JLwDtd/eeoifomILtKkVp3
         WKmb8cA8lKoltqrAUTxD4mi0SIhVobLgzUWUwoK3acvlEBLwpS5Nr1JW3i5lvRLz5y
         ApQ14ozND+1mDju9O64HlwXtw5s4R6+2+7Vk0xbk=
Date:   Thu, 11 Jul 2019 08:43:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ran Wang <ran.wang_1@nxp.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Xiaobo Xie <xiaobo.xie@nxp.com>
Subject: Re: [PATCH AUTOSEL 5.1 08/39] arm64: dts: ls1028a: Fix CPU idle fail.
Message-ID: <20190711064305.GA10089@kroah.com>
References: <20190703021514.17727-1-sashal@kernel.org>
 <20190703021514.17727-8-sashal@kernel.org>
 <DB8PR04MB6826A4A8CE604F2570DC1EA7F1F30@DB8PR04MB6826.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6826A4A8CE604F2570DC1EA7F1F30@DB8PR04MB6826.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 05:04:24AM +0000, Ran Wang wrote:
> Hi Sasha, 
> 
>     Thanks for helping port this patch to stable.
>     May I know if I can submit other bug fixes which has been accepted by upstream to stable by myself?
>     If yes, where I can find related process for reference?

Sure!, please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

