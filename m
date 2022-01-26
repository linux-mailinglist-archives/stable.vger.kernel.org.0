Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA6C49CB1D
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiAZNoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240940AbiAZNoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:44:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA3CC06161C;
        Wed, 26 Jan 2022 05:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QdiVMTsBQEDXkyCoOFjWSQHA27
        /kjQXeRBpeVSeLzOh92O6ln63yj3KNgEDVsLB2tSciWHErAqAATPV/PyBmbF0YcigLlCrumi4/OoP
        JF2w9aooQQThcOaWKbvvoanPPqOcYg6lHOA2qC5+TodZ4uRK/xsJQ6cXjdBHkxDJWFFRRgratE+ir
        7ZSPFRnjbqnbA18piaFiaeH5YWAvYOkfAwYCg6HQ/FtH9xKB8ewfWEoVgyvHEQyZXNmxItCI731om
        R2BG2qm+jdrq8S4PeZB7dUSwIF53siqkoyadxWGB69Sqq3DthcLGRAYAthI0+rYgyiLuDfixom+hP
        sVfNwB0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nCiac-00Bu9k-P6; Wed, 26 Jan 2022 13:43:58 +0000
Date:   Wed, 26 Jan 2022 05:43:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Maciej W. Rozycki" <macro@embecosm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] tty: Partially revert the removal of the Cyclades
 public API
Message-ID: <YfFQHoKTZUs24lhO@infradead.org>
References: <alpine.DEB.2.20.2201260733430.11348@tpp.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.2201260733430.11348@tpp.orcam.me.uk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
