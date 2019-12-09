Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387D7117657
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 20:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLITxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 14:53:01 -0500
Received: from first.geanix.com ([116.203.34.67]:47468 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbfLITxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 14:53:01 -0500
Received: from [192.168.100.11] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 7129544B;
        Mon,  9 Dec 2019 19:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1575921158; bh=QFwYm8hCLkuo7sLI9TokuPqzgO4RIT9zOuxFCQwMVh8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=HKHlw/DPV1j58jXV05r7U0r4CXshCV+P534wAyjOnLJbd5+eTSaiUhN4voWV4AKNu
         nir3ZX6A7bj8+Jej2JXN9xVPaCXpEz/7nCfiBuNvA2kkqg2nM115m0MDIv6lBAwPgz
         1qWD987ayc0kr3/vdpeeYBY4NRW4wJIpCm9ZMX3vHHjwPbkOp36yQGkl/Bq3qTr/9d
         DjnUqzxya5qqIUG5UgIrlDhcDQW6JAWv26PBgRmvcKu9+UK53+mLAEZmIIy/dC297H
         arKejzSiox53wFH00DvYvmaMgkkma/D73nS0fkc3OrGr1QXwea54Ba8JdRO5QKQK0r
         UXbWz3UgHzAlA==
Subject: Re: [PATCH v2 1/2] can: m_can: tcan4x5x: put the device out of
 standby before register access
To:     Marc Kleine-Budde <mkl@pengutronix.de>, dmurphy@ti.com,
        linux-can@vger.kernel.org
Cc:     martin@geanix.com, stable@vger.kernel.org
References: <20191209192440.998659-1-sean@geanix.com>
 <78903660-2471-ee36-404b-4c9d2af02fc6@pengutronix.de>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <a40b5bba-1c8d-7911-bc37-9aab6816e227@geanix.com>
Date:   Mon, 9 Dec 2019 20:52:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <78903660-2471-ee36-404b-4c9d2af02fc6@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 09/12/2019 20.44, Marc Kleine-Budde wrote:
> On 12/9/19 8:24 PM, Sean Nyekjaer wrote:
>> The m_can tries to detect of niso (canfd) is available while in standby,
> 
> What's "of niso"?
> 
Should have been "if niso" :)

Non ISO Operation

0 – CAN FD Frame format according to ISO 11898-1:2015

1 – CAN FD Frame format according to Bosch CAN FD
  Specification V1.0

/Sean
