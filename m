Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3307A1DBE3A
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 21:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgETTpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 15:45:19 -0400
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:60928 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETTpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 15:45:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jbUeT-0007ee-49; Wed, 20 May 2020 20:45:17 +0100
Message-ID: <0fa517f4672e45bbb11aeb57cfb2740b60f1f998.camel@codethink.co.uk>
Subject: [stable] i2c: dev: Fix the race between the release of i2c_dev and
 cdev
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>
Date:   Wed, 20 May 2020 20:45:15 +0100
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please pick this fix for all stable branches:

commit 1413ef638abae4ab5621901cf4d8ef08a4a48ba6
Author: Kevin Hao <haokexin@gmail.com>
Date:   Fri Oct 11 23:00:14 2019 +0800

    i2c: dev: Fix the race between the release of i2c_dev and cdev

I don't know whether it will apply cleanly to all of them; I can deal
with those where it doesn't.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

