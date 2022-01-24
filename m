Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F79497BCB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 10:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbiAXJWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 04:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiAXJWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 04:22:17 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F398BC06173B;
        Mon, 24 Jan 2022 01:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rwUuQfNEdwxCQq/Ssl5OmKN2JZuyN3Dc7y/FK2VCJlg=; b=GD3wxa3RbB+vnusvPxeAOakeUp
        pRpPk+La6wa0akFgfhudTIHnrnQzLXAeplpezWzp4MnGwhIcxrptNGTfVHiMGOK4jijEAkxqW0Zto
        +PnPihR6342QQSldghmF9YYsfSxgvOTs4Au0X8OLnxHk9yzx238uLOCiRLAMrMIDZBxEcKBhhBudO
        Y5QYOiSgKlQFz5t62iQL5AulDkC9lgDN3knzDizQbHC8Is6Misdu1Pi13CViwt0c6F8cHxcDij1Tr
        UhHmUL/hChjUaDg1hFYQuxJonX4uC8dEXtlKrPzKguQU6QohAi2VaCpUwbXZBae8kXHDm+HGXZ09I
        nF54zMpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nBvYF-002m3r-Tu; Mon, 24 Jan 2022 09:22:15 +0000
Date:   Mon, 24 Jan 2022 01:22:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Maciej W. Rozycki" <macro@embecosm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] tty: Partially revert the removal of the Cyclades
 public API
Message-ID: <Ye5vx/8CYH2zWK28@infradead.org>
References: <alpine.DEB.2.20.2201230148120.11348@tpp.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.2201230148120.11348@tpp.orcam.me.uk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 23, 2022 at 01:32:45PM +0000, Maciej W. Rozycki wrote:
> Fix a user API regression introduced with commit f76edd8f7ce0 ("tty: 
> cyclades, remove this orphan"), which removed a part of the API and 
> caused compilation errors for user programs using said part, such as 
> GCC 9 in its libsanitizer component[1]:

This looks sensible, but a #warning might be useful to get people to
stop including this random header.
