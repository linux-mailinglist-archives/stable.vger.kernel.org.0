Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2A7605E26
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 12:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiJTKsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 06:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJTKr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 06:47:59 -0400
X-Greylist: delayed 1060 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Oct 2022 03:47:58 PDT
Received: from level.ms.sapientia.ro (level.ms.sapientia.ro [193.16.218.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DC861C7124
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 03:47:58 -0700 (PDT)
Received: from localhost (level.ms.sapientia.ro [127.0.0.1])
        by level.ms.sapientia.ro (Postfix) with ESMTP id EFA8A5E84578;
        Thu, 20 Oct 2022 13:21:45 +0300 (EEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 level.ms.sapientia.ro EFA8A5E84578
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ms.sapientia.ro;
        s=default; t=1666261306;
        bh=1iYwqtjHRQ8c22/evwAFD3L0nsEfp8iq1XhS+tgelCw=;
        h=Date:From:To:Subject:Reply-To:From;
        b=hLkrva/fkD5+b8ILCAnkHZv9RUo0RML3w1WB5PIAtK0D/vce9q6MeB5sU97wTaNJb
         4zq32zMUL/NsG6sErXIFSb//1GbVgpcSZdrOQAJrvABjvLUBjOLYFZ5VfpG/JVAboC
         fYUd/BI7p56KODzUd38GwOLyM2qaoTUT+wXKCbVM=
X-Virus-Scanned: by B3 SapScan
Received: from level.ms.sapientia.ro ([127.0.0.1])
        by localhost (level.ms.sapientia.ro [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zss8GR28flQB; Thu, 20 Oct 2022 13:21:44 +0300 (EEST)
Received: from level.ms.sapientia.ro (level.ms.sapientia.ro [127.0.0.1])
        by level.ms.sapientia.ro (Postfix) with ESMTPSA id 024EA5C69FF5;
        Thu, 20 Oct 2022 13:21:38 +0300 (EEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 level.ms.sapientia.ro 024EA5C69FF5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ms.sapientia.ro;
        s=default; t=1666261300;
        bh=1iYwqtjHRQ8c22/evwAFD3L0nsEfp8iq1XhS+tgelCw=;
        h=Date:From:To:Subject:Reply-To:From;
        b=b07dfcX1vLVi7x68DiR8fiXqB2BwIyeTIP0g6uZmkkFZ0T+hYoEPuH+vpPXFzle/u
         ZqTtMq5j3Q2vjMptn7yXOFpwoiOFY141dxqnILDnv0AmGvlu+A2BtavmjARNMBUclO
         pytcC7MMegDqf/e9BWny9d0a4LWipVNhECS0bQ64=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Oct 2022 12:21:38 +0200
From:   Evan <molnarkati@ms.sapientia.ro>
To:     undisclosed-recipients:;
Subject: Hi Gorgeous,
Reply-To: bakker.evan01@gmail.com
Mail-Reply-To: bakker.evan01@gmail.com
Message-ID: <4412d21e98eada0316f01a047b07ebd1@ms.sapientia.ro>
X-Sender: molnarkati@ms.sapientia.ro
User-Agent: Roundcube Webmail/1.3.4
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,ODD_FREEM_REPTO,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: sapientia.ro]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [bakker.evan01[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  2.9 ODD_FREEM_REPTO Has unusual reply-to header
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Gorgeous,
Am sorry to bother you, but I am single and lonely in need of a caring, 
loving and romantic companion.
I am a secret admirer and would like to explore the opportunity to learn 
more about each other.
Hopefully it will be the beginning of a long term communication between 
the both of us.
Please let me know what you think. will be glad to hear from you again.
Hugs and kisses,
Evan.
