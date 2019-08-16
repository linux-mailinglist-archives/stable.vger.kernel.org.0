Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0971890B49
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 01:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbfHPXD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 19:03:58 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:51400 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbfHPXD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 19:03:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone.i.decadent.org.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hylGG-0004nk-JM; Sat, 17 Aug 2019 00:03:56 +0100
Date:   Sat, 17 Aug 2019 00:03:55 +0100
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.9 02/13] bpf: restrict access to core bpf sysctls
Message-ID: <20190816230354.GR9843@xylophone.i.decadent.org.uk>
References: <20190816220431.GA9843@xylophone.i.decadent.org.uk>
 <20190816225956.GF9843@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816225956.GF9843@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, I've mis-threaded these.  These patch for 4.9 should be applied
after "[PATCH 4.9 01/13] bpf: get rid of pure_initcall dependency to
enable jits".

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom
