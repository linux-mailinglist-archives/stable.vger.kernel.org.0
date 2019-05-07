Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4BC15BBB
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfEGF5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:57:06 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41809 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728539AbfEGF5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 01:57:05 -0400
Received: by mail-lj1-f193.google.com with SMTP id k8so13128312lja.8
        for <stable@vger.kernel.org>; Mon, 06 May 2019 22:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C7TwO1vjbNHfMqbAxi9vlDVvmDYxhZ6ib+epFPKTheM=;
        b=TDEjJvzcgnurW1FPZtCH9rYP2rDymIZeqdMqRdGI15WUsXRAn3v7+lnmyZ0fdZGIeF
         Pc5D+zhVmkFbz3l3w4gfKZ2EnMZd+l84USSuNcl+9kMp8kUMYmIHDBt8nJJyKVkqp9N6
         bfTxje9VGE12bymK8hn65n+jfWRpU1o46JJJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C7TwO1vjbNHfMqbAxi9vlDVvmDYxhZ6ib+epFPKTheM=;
        b=ewx4hfGrizROrqlTZwGQTdZ4I0yGNOrceC0zuahW8pzGwOpZMIVbZXDdGnAqlbRY/r
         ccqRKQXjsQjiIti95Xi4k9cT1rkoLSdozNbaM4At5V9rJdO6PRBnpQ2uCLUfGvmeFovl
         Nx6jb9H5ZcQBFz8uOdWYfuW7t+luUUkTzWfiisX9zTDO7gmo+Pwwa+2RZ+Ry+HFqiZbo
         Jblqd9Ej+Oik0MmJIhhMXY7/svZUE7UqkM8YT4A2TBi22H9ZjhNerNBeafNWR23Maurk
         IjCInQrj8RRR8gWp1+AfHDDd+BufsZ9r5xkwAZF4YIhMDVUCCbd9QLCoRRCjWxD5fiTF
         2N2Q==
X-Gm-Message-State: APjAAAVG3s7QWs1gEGTYTfeDJG+/YNfXLn+DbL4mz8K11cpr4oeeR+MF
        GFFvYZEqPcU16DgtnptJFEbUPg==
X-Google-Smtp-Source: APXvYqwERnjT55opTEsv307+a6frciS871V94u2tJ9NDGTgJXKuYC1Zj43Kpzyifcos6RVOT/S+r2A==
X-Received: by 2002:a2e:84ca:: with SMTP id q10mr2535264ljh.117.1557208623493;
        Mon, 06 May 2019 22:57:03 -0700 (PDT)
Received: from [172.16.11.26] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id s17sm1889372lfb.66.2019.05.06.22.57.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 22:57:02 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 4.14 79/95] x86/asm: Remove dead __GNUC__
 conditionals
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-79-sashal@kernel.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <d18bba8c-0d2c-03bd-0098-5f39ad726b01@rasmusvillemoes.dk>
Date:   Tue, 7 May 2019 07:57:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507053826.31622-79-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/05/2019 07.38, Sasha Levin wrote:
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> [ Upstream commit 88ca66d8540ca26119b1428cddb96b37925bdf01 ]
> 
> The minimum supported gcc version is >= 4.6, so these can be removed.

Eh, that bump happened for the 4.19 kernel, so this is not true for the
4.14 branch. Has cafa0010cd51fb711fdcb50fc55f394c5f167a0a been applied
to 4.14.y? Otherwise I don't think this is appropriate.

Rasmus
