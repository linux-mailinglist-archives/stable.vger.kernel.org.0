Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4281257027
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 21:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgH3T1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 15:27:53 -0400
Received: from gofer.mess.org ([88.97.38.141]:56139 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgH3T1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Aug 2020 15:27:53 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 5F098C6410; Sun, 30 Aug 2020 20:27:52 +0100 (BST)
Date:   Sun, 30 Aug 2020 20:27:52 +0100
From:   Sean Young <sean@mess.org>
To:     stable@vger.kernel.org
Cc:     grumpy@mailfence.com
Subject: Please merge ea8912b788f8 to v5.7 and earlier signal due to
 scheduling"
Message-ID: <20200830192752.GA30468@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

This commit is in v5.8 but it is affecting users in earlier kernels. I'd
like to propose this commit for merging to all earlier stable kernels.

$ git log --oneline -1 ea8912b788f8144e7d32ee61e5ccba45424bef83
ea8912b788f8 media: gpio-ir-tx: improve precision of transmitted signal due to scheduling

Thanks,

Sean 
