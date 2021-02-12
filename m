Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE5131A062
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 15:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhBLOMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 09:12:32 -0500
Received: from mail.netline.ch ([148.251.143.178]:35932 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhBLOMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 09:12:32 -0500
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2021 09:12:31 EST
Received: from localhost (localhost [127.0.0.1])
        by netline-mail3.netline.ch (Postfix) with ESMTP id 4FFAD2A6045;
        Fri, 12 Feb 2021 15:01:23 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at netline-mail3.netline.ch
Received: from netline-mail3.netline.ch ([127.0.0.1])
        by localhost (netline-mail3.netline.ch [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id vkV0bfZJWGJB; Fri, 12 Feb 2021 15:01:23 +0100 (CET)
Received: from thor (24.99.2.85.dynamic.wline.res.cust.swisscom.ch [85.2.99.24])
        by netline-mail3.netline.ch (Postfix) with ESMTPSA id 622122A6042;
        Fri, 12 Feb 2021 15:01:21 +0100 (CET)
Received: from [::1]
        by thor with esmtp (Exim 4.94)
        (envelope-from <michel@daenzer.net>)
        id 1lAZ0b-000BpT-Bs; Fri, 12 Feb 2021 15:01:21 +0100
To:     Emil Velikov <emil.l.velikov@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "# 3.13+" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20210205163752.11932-1-chris@chris-wilson.co.uk>
 <20210205220012.1983-1-chris@chris-wilson.co.uk>
 <CACvgo52u1ASWXOuWuDwoXvbZhoq+RHn_GTxD5y9k+kO_dzmT7w@mail.gmail.com>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Subject: Re: [PATCH v3] kcmp: Support selection of SYS_kcmp without
 CHECKPOINT_RESTORE
Message-ID: <3a2316b6-27a9-d56a-b488-ac15a402a0d2@daenzer.net>
Date:   Fri, 12 Feb 2021 15:01:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CACvgo52u1ASWXOuWuDwoXvbZhoq+RHn_GTxD5y9k+kO_dzmT7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-02-12 1:57 p.m., Emil Velikov wrote:
> On Fri, 5 Feb 2021 at 22:01, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>
>> Userspace has discovered the functionality offered by SYS_kcmp and has
>> started to depend upon it. In particular, Mesa uses SYS_kcmp for
>> os_same_file_description() in order to identify when two fd (e.g. device
>> or dmabuf)
> 
> As you rightfully point out, SYS_kcmp is a bit of a two edged sword.
> While you mention the CONFIG issue, there is also a portability aspect
> (mesa runs on more than just linux) and as well as sandbox filtering
> of the extra syscall.
> 
> Last time I looked, the latter was still an issue and mesa was using
> SYS_kcmp to compare device node fds.
> A far shorter and more portable solution is possible, so let me
> prepare a Mesa patch.

Make sure to read my comments on 
https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/6881 first. :)


-- 
Earthling Michel Dänzer               |               https://redhat.com
Libre software enthusiast             |             Mesa and X developer
