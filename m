Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4497B81443
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 10:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfHEIco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 04:32:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:49186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726656AbfHEIco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 04:32:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0BA75AF1E;
        Mon,  5 Aug 2019 08:32:43 +0000 (UTC)
Date:   Mon, 5 Aug 2019 10:32:42 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     <gregkh@linuxfoundation.org>
Cc:     andrew@lunn.ch, arnd@arndb.de, bgolaszewski@baylibre.com,
        brgl@bgdev.pl, srinivas.kandagatla@linaro.org,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] eeprom: at24: make spd world-readable
 again" failed to apply to 4.19-stable tree
Message-ID: <20190805103242.4816abcc@endymion>
In-Reply-To: <1564982748230183@kroah.com>
References: <1564982748230183@kroah.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, 05 Aug 2019 07:25:48 +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.19-stable tree.

Technically it applies. Just it doesn't build ;-)

> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

The backport is trivial, I'll take care of it, thanks.

-- 
Jean Delvare
SUSE L3 Support
