Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF7BFE6B2
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 21:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfKOU7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 15:59:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44396 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfKOU7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 15:59:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4av0+SBD1vMrf5zA32ZYJgLjHtl85+9kbIX+2Olyi+I=; b=fU56JVprSEQyoiHJfIPWJd2oA
        wsFe+b0oNyR5hGs8sNcp+91MJE6ol/f/iom/RdVYHTyCVvRbViLkSvFkdCmUMcAw6A7ugagRkcw4F
        PhYENfIikdQIUk2D6TA1kZPKpSUGs7dGmdOwTZSJZEw8tVE7HATvLZkhZZtQc9cuKF376i+nj98nL
        /jwSFQMjJS2bJ6HSDvhIt+HvOLH+9mnhO6rmwRsFY4Vyg7sb9ZhS1NE5lcECAG3sowFPfwwgP7itk
        fbnRaNK//Rsi2pOOOnMuCNY5z4DbacKmQjfPXf9NjHbSBOT2VeMr6BneCQPcQtN6cJF4y/+mWvcwv
        x+EF4AJXw==;
Received: from [2601:1c0:6280:3f0::5a22]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iViga-0002KT-7S; Fri, 15 Nov 2019 20:59:20 +0000
Subject: Re: PROBLEM: error and warning from 5.4.0-rc7
To:     Jeffrin Jose <jeffrin@rajagiritech.edu.in>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
References: <20191115202559.GA160812@debian>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fe379dcc-5a43-4300-0ab6-458c493db888@infradead.org>
Date:   Fri, 15 Nov 2019 12:59:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191115202559.GA160812@debian>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/19 12:25 PM, Jeffrin Jose wrote:
> hello all
> 
> i get error and warning from a typical 5.4.0-rc7.
> 
> ------x--------x--error---x---------------x----
> 
> $cat 5.4.0-rc7-error.txt 
> [    2.064029] Couldn't get size: 0x800000000000000e
> [   12.906185] tpm_tis MSFT0101:00: IRQ index 0 not found

Hi,
Missing a lot of context here.

"Couldn't get size:" is from security/integrity/platform_certs/load_uefi.c.
The "size" that is printed appears to be EFI_NOT_FOUND, so it seems that
some error handling is not happening.

#define EFI_NOT_FOUND		(14 | (1UL << (BITS_PER_LONG-1)))

Adding a few cc:s.

-- 
~Randy

