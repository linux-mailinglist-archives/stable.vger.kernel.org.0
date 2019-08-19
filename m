Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532C994AF7
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 18:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfHSQxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 12:53:22 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:59978 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfHSQxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 12:53:22 -0400
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hzkuG-00082L-5V; Mon, 19 Aug 2019 17:53:20 +0100
Message-ID: <35579e00d27344b853cafea0b29b13c5aaf9e1fc.camel@codethink.co.uk>
Subject: Re: [PATCH AUTOSEL 4.4 01/14] xtensa: fix build for cores with
 coprocessors
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, linux-xtensa@linux-xtensa.org
Date:   Mon, 19 Aug 2019 17:53:19 +0100
In-Reply-To: <20190806213749.20689-1-sashal@kernel.org>
References: <20190806213749.20689-1-sashal@kernel.org>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-08-06 at 17:37 -0400, Sasha Levin wrote:
> From: Max Filippov <jcmvbkbc@gmail.com>
> 
> [ Upstream commit e3cacb73e626d885b8cf24103fed0ae26518e3c4 ]
> 
> Assembly entry/return abstraction change didn't add asmmacro.h include
> statement to coprocessor.S, resulting in references to undefined macros
> abi_entry and abi_ret on cores that define XTENSA_HAVE_COPROCESSORS.
> Fix that by including asm/asmmacro.h from the coprocessor.S.
[...]

This seems to be fixing commit d6d5f19e21d9 "xtensa: abstract 'entry'
and 'retw' in assembly code" so it wouldn't be needed for any stable
branches.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

