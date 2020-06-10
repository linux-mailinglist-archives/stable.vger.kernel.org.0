Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDDB1F560F
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 15:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgFJNo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 09:44:58 -0400
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:48880 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgFJNo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 09:44:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jj12E-0001Lo-Kg; Wed, 10 Jun 2020 14:44:54 +0100
Message-ID: <5935bba37ea9f7421e316b7d554508b0f652c027.camel@codethink.co.uk>
Subject: Re: [PATCH AUTOSEL 5.6 080/606] i2c: dev: Fix the race between the
 release of i2c_dev and cdev
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Kevin Hao <haokexin@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-i2c@vger.kernel.org
Date:   Wed, 10 Jun 2020 14:44:53 +0100
In-Reply-To: <20200608231211.3363633-80-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
         <20200608231211.3363633-80-sashal@kernel.org>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-06-08 at 19:03 -0400, Sasha Levin wrote:
> From: Kevin Hao <haokexin@gmail.com>
> 
> commit 1413ef638abae4ab5621901cf4d8ef08a4a48ba6 upstream.
[...]

This was already applied in 5.6.15.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

