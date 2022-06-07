Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70129541711
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377200AbiFGU6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377260AbiFGU5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:57:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0C92010FF;
        Tue,  7 Jun 2022 11:44:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8AE76160D;
        Tue,  7 Jun 2022 18:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E06C385A5;
        Tue,  7 Jun 2022 18:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627458;
        bh=fjh0DjFNqa4PrftEH5DvKhHI7w1fRCD7pD5OezHZF+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ce3VGHjmOEWq/nJ8GNSkk5UfDbO0lM+MQ/GINzze+kia92iwbBydgcSbX0FC3SiIR
         Aw1vRB814MXRnZZ0pL+aMGNhJB8oRNNLLK8mmAMMRne/o1pqH2LAX/oeb+/bXJiW2e
         6IFoxT0Uh+aPjLWRLsXofyq0a3b7GY53rH8pIvBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akira Yokosawa <akiyks@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.17 748/772] docs/conf.py: Cope with removal of language=None in Sphinx 5.0.0
Date:   Tue,  7 Jun 2022 19:05:40 +0200
Message-Id: <20220607165011.070683016@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
@@ -161,7 +161,7 @@ finally:
 #
 # This is also used if you do content translation via gettext catalogs.
 # Usually you set "language" from the command line for these cases.
-language = None
+language = 'en'
 
 # There are two options for replacing |today|: either, you set today to some
 # non-false value, then it is used:


