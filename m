Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC50548982
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242470AbiFMKZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245073AbiFMKYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:24:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9711A205DF;
        Mon, 13 Jun 2022 03:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F93DB80E92;
        Mon, 13 Jun 2022 10:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC671C34114;
        Mon, 13 Jun 2022 10:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115514;
        bh=7xf9iBHpNNLxSetGM17NzppiizC8ZCsYKWufW33KuuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhtunJxoASVIXrOFmVr9tGQkloMoSf+flxt8LGwz2mC6Pf7BF5Z8/z3QNDS+qxk9J
         nFgJ7P6wmAFLYOUsfFicDc7g/Sbc3f6jOQ4WNvspOMcYX6D6LEYWKs5X5GysVVIyrL
         BkkRypyMnRCh7YnKMSwo5mecvTh4R6J7TEcV7C2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akira Yokosawa <akiyks@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4.9 103/167] docs/conf.py: Cope with removal of language=None in Sphinx 5.0.0
Date:   Mon, 13 Jun 2022 12:09:37 +0200
Message-Id: <20220613094904.906801705@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akira Yokosawa <akiyks@gmail.com>

commit 627f01eab93d8671d4e4afee9b148f9998d20e7c upstream.

One of the changes in Sphinx 5.0.0 [1] says [sic]:

    5.0.0 final

     - #10474: language does not accept None as it value.
       The default value of language becomes to 'en' now.

[1]: https://www.sphinx-doc.org/en/master/changes.html#release-5-0-0-released-may-30-2022

It results in a new warning from Sphinx 5.0.0 [sic]:

    WARNING: Invalid configuration value found: 'language = None'.
    Update your configuration to a valid langauge code. Falling
    back to 'en' (English).

Silence the warning by using 'en'.
It works with all the Sphinx versions required for building
kernel documentation (1.7.9 or later).

Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Link: https://lore.kernel.org/r/bd0c2ddc-2401-03cb-4526-79ca664e1cbe@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/conf.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -96,7 +96,7 @@ finally:
 #
 # This is also used if you do content translation via gettext catalogs.
 # Usually you set "language" from the command line for these cases.
-language = None
+language = 'en'
 
 # There are two options for replacing |today|: either, you set today to some
 # non-false value, then it is used:


