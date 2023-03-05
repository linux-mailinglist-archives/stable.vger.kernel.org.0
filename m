Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820D56AEE6A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbjCGSLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbjCGSLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:11:07 -0500
X-Greylist: delayed 87455 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Mar 2023 10:06:17 PST
Received: from correo-per.policiadeentrerios.gob.ar (unknown [190.216.32.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453A3A6144
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:06:16 -0800 (PST)
Received: from correo-per.policiadeentrerios.gob.ar (localhost [127.0.0.1])
        by correo-per.policiadeentrerios.gob.ar (Postfix) with ESMTPS id 17D171661F08;
        Tue,  7 Mar 2023 12:08:45 -0300 (ART)
Received: from localhost (localhost [127.0.0.1])
        by correo-per.policiadeentrerios.gob.ar (Postfix) with ESMTP id F38CE1A41C40;
        Sun,  5 Mar 2023 20:06:34 -0300 (ART)
DKIM-Filter: OpenDKIM Filter v2.9.2 correo-per.policiadeentrerios.gob.ar F38CE1A41C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=policiadeentrerios.gob.ar; s=2E3A7FFA-A084-11EC-84B5-4EEE2774B71F;
        t=1678057595; bh=q/iIbapuLTt5UCMwZBcD36jqBn0wPs8yyje8th2aVPA=;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:To:
         From:Date:Reply-To:Message-Id;
        b=EGhXb+xtumJM6ua41v0XRZQsdtN9PTBxp2xr/5aLHDZo9Z/kPe6Uoksng3JT/lgMs
         hOUfX21qwUBPeVHcn4HFx1XfzZWiOShXHtqmOk1rve7AWMXBxlBHePtu7MuhHB31KT
         mXyJA3O2v7cchrDa5o5erxIYQ6SZDFB+geBnmKog=
Received: from correo-per.policiadeentrerios.gob.ar ([127.0.0.1])
        by localhost (correo-per.policiadeentrerios.gob.ar [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XbSls9GvIR-b; Sun,  5 Mar 2023 20:06:34 -0300 (ART)
Received: from [10.2.0.2] (unknown [185.107.56.76])
        by correo-per.policiadeentrerios.gob.ar (Postfix) with ESMTPSA id C08CF1A08E48;
        Sun,  5 Mar 2023 19:44:22 -0300 (ART)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: re
To:     Recipients <jdna_dsgyp@policiadeentrerios.gob.ar>
From:   "Yuliia Kadulina" <jdna_dsgyp@policiadeentrerios.gob.ar>
Date:   Mon, 06 Mar 2023 04:13:51 +0530
Reply-To: kadulinayuliiia@gmail.com
Message-Id: <20230305224427.C08CF1A08E48@correo-per.policiadeentrerios.gob.ar>
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_99,BAYES_999,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_REPLYTO,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: gob.ar]
        *  0.2 BAYES_999 BODY: Bayes spam probability is 99.9 to 100%
        *      [score: 1.0000]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 1.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Top of the day to you, I'm Yuliia Kadulina Deputy Chairman of the Managemen=
t Board, and Personal Finance Director at Ukrsibbank Ukraine. I have a prop=
osal for you. Kindly revert so I can fill you in on the details.

Thanks,
Yuliia
