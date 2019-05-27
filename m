Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B582BBDE
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 23:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfE0Vzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 17:55:48 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:52599 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfE0Vzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 17:55:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hVNar-0002th-8K; Mon, 27 May 2019 22:55:45 +0100
Message-ID: <1558994144.2631.14.camel@codethink.co.uk>
Subject: [stable] bpf: add bpf_jit_limit knob to restrict unpriv allocations
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Date:   Mon, 27 May 2019 22:55:44 +0100
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please consider backporting this commit to 4.19-stable:

commit ede95a63b5e84ddeea6b0c473b36ab8bfd8c6ce3
Author: Daniel Borkmann <daniel@iogearbox.net>
Date:   Tue Oct 23 01:11:04 2018 +0200

    bpf: add bpf_jit_limit knob to restrict unpriv allocations

No other stable branches are affected by the issue.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom
