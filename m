Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3024239EAA
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 07:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgHCFRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 01:17:06 -0400
Received: from mailout09.rmx.de ([94.199.88.74]:53849 "EHLO mailout09.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727949AbgHCFRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 01:17:06 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout09.rmx.de (Postfix) with ESMTPS id 4BKmN00YCCzbjDl
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 07:17:04 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4BKmMs33cVz2TT2K
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 07:16:57 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.30) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 3 Aug
 2020 07:16:46 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Sasha Levin <sashal@kernel.org>
CC:     Jonathan Cameron <jic23@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] iio: trigger: hrtimer: Disable irqs before calling iio_trigger_poll()
Date:   Mon, 3 Aug 2020 07:16:35 +0200
Message-ID: <1820630.DtBXrsn14p@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20200730134812.22ACD208A9@mail.kernel.org>
References: <20200727145900.4563-1-ceggers@arri.de> <20200730134812.22ACD208A9@mail.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.30]
X-RMX-ID: 20200803-071703-4BKmMs33cVz2TT2K-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thursday, 30 July 2020, 15:48:11 CEST, Sasha Levin wrote:
> The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135,
> v4.14.190, v4.9.231, v4.4.231.
> 
> v5.7.11: Build OK!
> v5.4.54: Build OK!
> v4.19.135: Build OK!
> v4.14.190: Build OK!
> v4.9.231: Build OK!
> v4.4.231: Failed to apply! Possible dependencies:
>     ac5006a2a558 ("iio: trigger: Introduce IIO hrtimer based trigger")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
Please apply for v4.9 and later.

regards
Christian



