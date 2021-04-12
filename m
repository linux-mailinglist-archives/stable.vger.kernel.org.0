Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C9235C844
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 16:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242072AbhDLOGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 10:06:31 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:38796 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242116AbhDLOGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 10:06:31 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 8371792009C; Mon, 12 Apr 2021 16:06:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 7CA1392009B;
        Mon, 12 Apr 2021 16:06:12 +0200 (CEST)
Date:   Mon, 12 Apr 2021 16:06:12 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Huacai Chen <chenhuacai@kernel.org>
cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: Remove unused and erroneous div64.h
In-Reply-To: <20210412033451.215379-1-chenhuacai@loongson.cn>
Message-ID: <alpine.DEB.2.21.2104121604150.65251@angie.orcam.me.uk>
References: <20210412033451.215379-1-chenhuacai@loongson.cn>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Apr 2021, Huacai Chen wrote:

> 5, As Nikolaus, Yunqiang Su and Yanjie Zhou said, the MIPS-specific
>    __div64_32() sometimes produces wrong results, which makes 32bit
>    kernel boot fails.
> 
> I have tried to fix theses errors but I have failed with the last one.

 I think this is a weak argument for removal, isn't it?

  Maciej
