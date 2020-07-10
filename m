Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2320621B7AE
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgGJODI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbgGJODH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:03:07 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85B49207D0;
        Fri, 10 Jul 2020 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389786;
        bh=/ndDXLQH3QwwxhH1L9G06wgIZCI7TfsObOs61gqUbc0=;
        h=Date:From:To:To:To:To:CC:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=GjHRu6gkFZbgsG/EcK+yirEbEomeKuKim9plPSUKOGOkMmjRcCNaZsxVwrWdpud3r
         d82xjuin2x9kHbexXvqFIzes6rqMUe0Y1f7GTqS67/2tzjbC9oFmrti+jsxg3YP9UY
         8LXCwKzmWBM8kGlYto1SNuGueiEYKYm0qgW9pOdY=
Date:   Fri, 10 Jul 2020 14:03:05 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     <qiang.zhang@windriver.com>
To:     Zhang Qiang <qiang.zhang@windriver.com>
To:     <balbi@kernel.org>
CC:     <colin.king@canonical.com>, <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4] usb: gadget: function: fix missing spinlock in f_uac1_legacy
In-Reply-To: <20200706051455.33198-1-qiang.zhang@windriver.com>
References: <20200706051455.33198-1-qiang.zhang@windriver.com>
Message-Id: <20200710140306.85B49207D0@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: c6994e6f067c ("USB: gadget: add USB Audio Gadget driver").

The bot has tested the following trees: v5.7.7, v5.4.50, v4.19.131, v4.14.187, v4.9.229, v4.4.229.

v5.7.7: Build OK!
v5.4.50: Build OK!
v4.19.131: Build OK!
v4.14.187: Build OK!
v4.9.229: Failed to apply! Possible dependencies:
    Unable to calculate

v4.4.229: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
