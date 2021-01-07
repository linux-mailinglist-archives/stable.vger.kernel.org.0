Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D386A2ED283
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbhAGOdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbhAGOdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D90E323340;
        Thu,  7 Jan 2021 14:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610030008;
        bh=kCr5BMiWWg5aFQwj+iROW1zQ5V/wRvNstNcq+ezvjlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcKhvkvH34N4TvEMqjdPkcYB5J3s4y6wWG4CJh3r+8pZC8EQE8wVgFHRTWJaJqpT6
         XV0tc415M1ZWI4KL2pL1mB+gY4gcGUfkt27WOdL5hENMxn1wNgnd/GvZfdOZd+JYQU
         H6aYRbaYgz4CAATDyx430JOOhgHlVAIhM9K41ao4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.10 05/20] dt-bindings: rtc: add reset-source property
Date:   Thu,  7 Jan 2021 15:34:00 +0100
Message-Id: <20210107143053.178973820@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

commit 320d159e2d63a97a40f24cd6dfda5a57eec65b91 upstream.

Some RTCs, e.g. the pcf2127, can be used as a hardware watchdog. But
if the reset pin is not actually wired up, the driver exposes a
watchdog device that doesn't actually work.

Provide a standard binding that can be used to indicate that a given
RTC can perform a reset of the machine, similar to wakeup-source.

Suggested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201218101054.25416-2-rasmus.villemoes@prevas.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/rtc/rtc.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/rtc/rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/rtc.yaml
@@ -63,6 +63,11 @@ properties:
     description:
       Enables wake up of host system on alarm.
 
+  reset-source:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      The RTC is able to reset the machine.
+
 additionalProperties: true
 
 ...


