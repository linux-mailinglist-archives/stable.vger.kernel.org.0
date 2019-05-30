Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC6E300D3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 19:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfE3RSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 13:18:04 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:60066 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfE3RSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 13:18:04 -0400
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hWOgj-0002oW-IM; Thu, 30 May 2019 18:18:01 +0100
Message-ID: <1559236680.24330.5.camel@codethink.co.uk>
Subject: Re: [stable] bpf: add bpf_jit_limit knob to restrict unpriv
 allocations
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Date:   Thu, 30 May 2019 18:18:00 +0100
In-Reply-To: <1558994144.2631.14.camel@codethink.co.uk>
References: <1558994144.2631.14.camel@codethink.co.uk>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2019-05-27 at 22:55 +0100, Ben Hutchings wrote:
> Please consider backporting this commit to 4.19-stable:
> 
> commit ede95a63b5e84ddeea6b0c473b36ab8bfd8c6ce3
> Author: Daniel Borkmann <daniel@iogearbox.net>
> Date:   Tue Oct 23 01:11:04 2018 +0200
> 
>     bpf: add bpf_jit_limit knob to restrict unpriv allocations
> 
> No other stable branches are affected by the issue.

Actually that's wrong; the commit introducing this was backported to
4.4, 4.9, and 4.14.  I haven't yet checked whether this fix applies
cleanly to them.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom
