Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A469498E
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 18:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfHSQMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 12:12:34 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:58672 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfHSQMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 12:12:34 -0400
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hzkGl-0006r0-CN; Mon, 19 Aug 2019 17:12:31 +0100
Message-ID: <5df8767ccc5f22d28597c33d67494caa5c681380.camel@codethink.co.uk>
Subject: Re: [PATCH 4.9 03/13] bpf: add bpf_jit_limit knob to restrict
 unpriv allocations
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Date:   Mon, 19 Aug 2019 17:12:30 +0100
In-Reply-To: <20190819160712.GB15418@sasha-vm>
References: <20190816220431.GA9843@xylophone.i.decadent.org.uk>
         <20190816230008.GG9843@xylophone.i.decadent.org.uk>
         <20190819160712.GB15418@sasha-vm>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2019-08-19 at 12:07 -0400, Sasha Levin wrote:
> On Sat, Aug 17, 2019 at 12:00:08AM +0100, Ben Hutchings wrote:
> > From: Daniel Borkmann <daniel@iogearbox.net>
> > 
> > commit ede95a63b5e84ddeea6b0c473b36ab8bfd8c6ce3 upstream.
[...]
> I've also queued up fdadd04931c2d ("bpf: fix bpf_jit_limit knob for
> PAGE_SIZE >= 64K") on top.

Well spotted.  That will be needed for 4.14 as well.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

