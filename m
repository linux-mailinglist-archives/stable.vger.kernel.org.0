Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1E94FA96B
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 18:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbiDIQKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 12:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiDIQKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 12:10:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1629B1B79C
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 09:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        Cc:Subject:From:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=o2wOndsDrNZV1TEZFXjrrx+NBVItbE5z2+7u1kmlBY0=; b=Ydkt3iwBvEsoP/NQUKAelwM7nr
        tFduHstYl6g/ViQNwUtj7+zOtV9Dn+dYPrHAuQMx538e3JsN2YSLC7wF/Y1JPLcxg/6YbZQFywMII
        +EnBDI6Ewn9msnZZF5QO6774ykakR3rYb9GsVkb0yAgZtcRNKkHm0XlYHGPjY+tBGak8549MIJGxG
        8Cqxg4wqcAOdT9ypvA0GCl7LjGcPCRqyqDunab+9J+sRUHbKd1eeA3dKmQx6N0NHCR9b7hPwczDf7
        qStIUyfLlWn1KunDsfmt79e2ciKyLTkPMOfAgkOAvWRkXXOfRqlFH0gxitLni1fpHr/0yse/zeZ24
        RiOppZng==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ndDcw-00Ao4Y-7f; Sat, 09 Apr 2022 16:07:54 +0000
Message-ID: <beaf8136-1c97-a65f-e64b-a98f23f024d2@infradead.org>
Date:   Sat, 9 Apr 2022 09:07:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: stable 5.10: please revert c4dc584a2d4c8d74b054f09d67e0a076767bdee5
Cc:     nanericwang@gmail.com, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to https://bugzilla.kernel.org/show_bug.cgi?id=215823,
c4dc584a2d4c8d74b054f09d67e0a076767bdee5 ("hv: utils: add PTP_1588_CLOCK to Kconfig to fix build")
is a problem for 5.10 since CONFIG_PTP_1588_CLOCK_OPTIONAL does not exist in 5.10.
This prevents the hyper-V NIC timestamping from working, so please revert that commit.

-- 
~Randy
