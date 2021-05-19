Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46036389685
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 21:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhESTV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 15:21:58 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:35170 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhESTV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 15:21:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id D87CB606BA4E;
        Wed, 19 May 2021 21:20:34 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id lS9jCYwelv0U; Wed, 19 May 2021 21:20:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 8EC5E60A3594;
        Wed, 19 May 2021 21:20:34 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1T46rIOgKzPk; Wed, 19 May 2021 21:20:34 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 66F7E616B56D;
        Wed, 19 May 2021 21:20:34 +0200 (CEST)
Date:   Wed, 19 May 2021 21:20:34 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     stable <stable@vger.kernel.org>
Cc:     tomas.melin@vaisala.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org
Message-ID: <919527621.20381.1621452034259.JavaMail.zimbra@nod.at>
Subject: Please backport b86f86e8e7c5 ("serial: 8250: fix potential deadlock
 in rs485-mode")
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Index: hqBNF9KYvvk63RA2cmny2kdaKWQidg==
Thread-Topic: Please backport b86f86e8e7c5 ("serial: 8250: fix potential deadlock in rs485-mode")
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

Please backport commit b86f86e8e7c5 ("serial: 8250: fix potential deadlock in rs485-mode") to stable.
The issue is real, I was hit by it on 4.14.

Thanks,
//richard
