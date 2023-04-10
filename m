Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD196DCB7C
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 21:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjDJTVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 15:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDJTVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 15:21:22 -0400
X-Greylist: delayed 242 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Apr 2023 12:21:20 PDT
Received: from mail.tty42.de (mail.tty42.de [IPv6:2a01:4f8:1c0c:804b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BCB1994
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 12:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pisquaredover6.de;
        s=rsa; t=1681154074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=R4yx+4YhMv2jCSmvwZDIS1UVrlVFXO/doFj6xumv1H4=;
        b=S7UmSrTj4WlepI2QsvrQ+U5p0kC3s3qy09wG8GgXlq0nvDa46gWN+8dXJUkLUKnwtPqDZP
        CZY73bub7seqIJsLaiMYcmtqo9FamXeq+DM28GbyqIaP5nM4HrVEp8dWAg9Gb3hYIsLfiq
        c2xdCSnbnqzTdAFkWNrdQQgA2ZvkMnunNw4SvXLUi5rn4HlmXOyDS1jAvIEVQtOW+oCuAA
        zUxL71lTFi3OgRrHYMpJLhlYJJdO9Ocum/6+TVJaYWblF+DKb4vxbu9GNRoydDz+HsP7XY
        gHTKuR0HgwvK+/myoWkiS9n+4Jz6dps6jrND6d7sBCrns7zG88V5U3ex+IfSzA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=pisquaredover6.de;
        s=dkim; t=1681154074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=R4yx+4YhMv2jCSmvwZDIS1UVrlVFXO/doFj6xumv1H4=;
        b=bIgLIAX1kbIEIYDwNJuqf5coZuywlrYWzDTdJ+MCrUahIgDBG2CCH3hQLqFdy6q1eQu59e
        R4iYlDh6sfZZxWCA==
Received: by mail.tty42.de (OpenSMTPD) with ESMTPSA id 8d4de6f9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 10 Apr 2023 19:14:34 +0000 (UTC)
Message-ID: <8e90142e-cdc3-a4a0-754a-4c7a2388940b@pisquaredover6.de>
Date:   Mon, 10 Apr 2023 21:14:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
From:   Veronika Schwan <veronika@pisquaredover6.de>
To:     Jerry.Zuo@amd.com
Cc:     stable@vger.kernel.org, mario.limonciello@amd.com
Subject: Regression in 6.2.10 monitors connected via MST hub stay black
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I found a regression while updating from 6.2.9 to 6.2.10 (Arch Linux).
After upgrading to 6.2.10, my external monitors stopped working (no 
input) when starting my display manager.
My hardware:
Lenovo T14s AMD gen 1
Lenovo USB-C Dock Gen 2 40AS (firmware up to date: 13.24)
2 monitors connected via dock and thus via an MST hub

Reverting commit d7b5638bd3374a47f0b038449118b12d8d6e391c fixes the issue.

Best regards,
Veronika
