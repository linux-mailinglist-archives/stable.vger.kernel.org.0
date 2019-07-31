Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109BE7BB53
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 10:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfGaIPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 04:15:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:52964 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726185AbfGaIPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 04:15:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 25221AE2C;
        Wed, 31 Jul 2019 08:15:38 +0000 (UTC)
Date:   Wed, 31 Jul 2019 10:15:37 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     SunKe <sunke32@huawei.com>
Cc:     josef@toxicpanda.com, axboe@kernel.dk, linux-block@vger.kernel.org,
        nbd@other.debian.org, linux-kernel@vger.kernel.org,
        kamatam@amazon.com, manoj.br@gmail.com, stable@vger.kernel.org,
        dwmw@amazon.com
Subject: Re: [PATCH] nbd: replace kill_bdev() with __invalidate_device() again
Message-ID: <20190731081536.GB3856@x250>
References: <1564542946-26255-1-git-send-email-sunke32@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564542946-26255-1-git-send-email-sunke32@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 11:15:46AM +0800, SunKe wrote:
> CR: https://code.amazon.com/reviews/CR-7629288

Hi, this link isn't accessible for ordinary people, please remove it from the
patch.

-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
