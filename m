Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19260499E61
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381599AbiAXWdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584595AbiAXWV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF58C0424E4;
        Mon, 24 Jan 2022 12:51:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D385D60907;
        Mon, 24 Jan 2022 20:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE78FC340E5;
        Mon, 24 Jan 2022 20:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057513;
        bh=A61Mjq671YKWOXyCgRwXP22r5uuFJFRpViFWZVpV9aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuPk3eEf9I4D801NHp5MpNNm3uZf82TKh2RDYtzLNZY8U4DAzedakg/bfgolSrsvD
         xiHLlORXx1Gc6NQvUZTCoBu/b2OWVPqpLEJIKvpN7V6nHdzQMwBPMpKa7YLiQk9KRr
         iwic7z6MdPdaA4sD0kRv4N7q0boYJiVeTQwdP+zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@mailbox.org>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 5.15 838/846] dt-bindings: display: meson-dw-hdmi: add missing sound-name-prefix property
Date:   Mon, 24 Jan 2022 19:45:55 +0100
Message-Id: <20220124184129.816173689@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@mailbox.org>

commit 22bf4047d26980807611b7e2030803db375afd87 upstream.

This is used in meson-gx and meson-g12. Add the property to the binding.
This fixes the dtschema warning:
hdmi-tx@c883a000: 'sound-name-prefix' does not match any of the
regexes: 'pinctrl-[0-9]+'

Signed-off-by: Alexander Stein <alexander.stein@mailbox.org>
Fixes: 376bf52deef5 ("dt-bindings: display: amlogic, meson-dw-hdmi: convert to yaml")
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211223122434.39378-2-alexander.stein@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/amlogic,meson-dw-hdmi.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/display/amlogic,meson-dw-hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/amlogic,meson-dw-hdmi.yaml
@@ -10,6 +10,9 @@ title: Amlogic specific extensions to th
 maintainers:
   - Neil Armstrong <narmstrong@baylibre.com>
 
+allOf:
+  - $ref: /schemas/sound/name-prefix.yaml#
+
 description: |
   The Amlogic Meson Synopsys Designware Integration is composed of
   - A Synopsys DesignWare HDMI Controller IP
@@ -99,6 +102,8 @@ properties:
   "#sound-dai-cells":
     const: 0
 
+  sound-name-prefix: true
+
 required:
   - compatible
   - reg


