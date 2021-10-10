Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113854283A8
	for <lists+stable@lfdr.de>; Sun, 10 Oct 2021 22:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhJJVBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Oct 2021 17:01:09 -0400
Received: from phobos.denx.de ([85.214.62.61]:48516 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233005AbhJJVBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Oct 2021 17:01:06 -0400
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 91AC782B68;
        Sun, 10 Oct 2021 22:59:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1633899546;
        bh=M60tgnnvgf/Z1EWVJfh5M6pOSl/vPxdp/XeddacR4eo=;
        h=To:From:Subject:Date:From;
        b=grFNbE8+BCAbqI7wcZeMGP9o0mHoiKEutlP18KVVWEQ/Vw6idPhX+kxVp/wlUQ6mg
         NGlugj8P2lUVaVOTUObmQs5tHFF+sOSxaIxw/tKnRhhBoBe5d5DTSmJ9CraPZvHuQl
         Em8IcgvMwaqo702LEnqmt5lpoWreiyp20ihxcuqMYYhbxOmYdLzvp/cm1mPsk4wPgB
         lVvZFn3qRTlHdsT6wlFdeYV8J9Fz8hkmVO78ngEzFrEo6RKF62q50NdgJ0epjANZFx
         2Bc/WsPgWHGV4UEU6eCXoifi5QtAea4bqsn3DdAz5xyCsjyEmGZODss/lY9oBZvXny
         bmMHw321myWpw==
To:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Marek Vasut <marex@denx.de>
Subject: [PATCH] Bluetooth: btusb: Add support for TP-Link UB500 Adapter
Message-ID: <aa3f6986-1e9b-4aaa-e498-fd99385f4063@denx.de>
Date:   Sun, 10 Oct 2021 22:59:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello everyone,

The following new device USB ID has landed in linux-next recently:

4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")

It would be nice if it could be backported to stable. I verified it 
works on 5.14.y as a simple cherry-pick .

Thank you
