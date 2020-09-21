Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381BC272458
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgIUMzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727055AbgIUMy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:57 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE4D820874;
        Mon, 21 Sep 2020 12:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692897;
        bh=YTX2FUJMA61MC//Hyghreyy7urvRmhmEcVuSrJ8McWM=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=AHPyzCgt7OZRRAmzWC8DQLDp676gZONzrkI5OZ6OEb6kwTF3+fNv+HhEJSKdmo/6A
         Foot9lpFJrIFkuOWDGIHCsfrYR/YSsbQQU7H2eUt1L+FDTqqyQbkxmr18sC3KZat2c
         K4ShI68ieWiuJC6bvwiM0Y0N020CWndUEyNhiaew=
Date:   Mon, 21 Sep 2020 12:54:56 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 09/10] xhci: don't create endpoint debugfs entry before ring buffer is set.
In-Reply-To: <20200918131752.16488-10-mathias.nyman@linux.intel.com>
References: <20200918131752.16488-10-mathias.nyman@linux.intel.com>
Message-Id: <20200921125456.EE4D820874@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 02b6fdc2a153 ("usb: xhci: Add debugfs interface for xHCI driver").

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Failed to apply! Possible dependencies:
    5afa0a5ed3da ("usb: xhci: add endpoint context tracing when an endpoint is added")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
