Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77F812082B
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 15:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfLPOIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 09:08:31 -0500
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:52670 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727807AbfLPOIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 09:08:31 -0500
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 368D62E131D;
        Mon, 16 Dec 2019 17:08:29 +0300 (MSK)
Received: from iva4-7c3d9abce76c.qloud-c.yandex.net (iva4-7c3d9abce76c.qloud-c.yandex.net [2a02:6b8:c0c:4e8e:0:640:7c3d:9abc])
        by mxbackcorp1g.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id WrbeDLEHcs-8SKalEVc;
        Mon, 16 Dec 2019 17:08:29 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1576505309; bh=+caJfa4RrGbn0IAEtwobzDXLP5OstLMGx0KJWgNP74U=;
        h=Message-ID:Subject:From:To:Cc:Date;
        b=EhwidzGQUurj4aH8ZD/owzxe9+umws3nn5FQJc+h46gtGCcO56HSprjvhWILvYr+Y
         oZOgt7qjhp07ieRO1FH2GfdIpftNxrsVcT+my7FQDtFOP8v/cCLp8dIlC/MqIEWPfD
         ZSI+IWQD6dMU9v3A6w1aYIG2iPJhw9mKgUYX+jnA=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [2a02:6b8:b080:7803::1:c])
        by iva4-7c3d9abce76c.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 9YVx63hX7j-8SUCxhLQ;
        Mon, 16 Dec 2019 17:08:28 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Mozilla-News-Host: news://news.gmane.org:119
To:     Stable <stable@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Please queue "ext4: fix leak of quota reservations" into 5.4.y
Message-ID: <9682429e-34a6-e8db-deec-b9628b1c6ba6@yandex-team.ru>
Date:   Mon, 16 Dec 2019 17:08:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit f4c2d372b89a1e504ebb7b7eb3e29b8306479366 ("ext4: fix leak of quota reservations")

Only 5.4 is affected.

As I see it wasn't autoselected.
Probably because it isn't tagged as stable@ as should be.
