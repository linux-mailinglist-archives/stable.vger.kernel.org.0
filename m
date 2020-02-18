Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A7163298
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgBRUIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:08:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgBRT5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:57:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 726EA24670;
        Tue, 18 Feb 2020 19:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055858;
        bh=5BanddPanjla8ZTGWbfTE9JVb11UW/XRK0aZm0tPR+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0joDewAIV3Qy/VVyN1o3iAKPjNjt3XXr/YGXcPkx5Q7CpkA3OIfSdXAkQgu+M5tcy
         MIiwMO7DLy1G8/Firtf9wYE7Qv/ovTaQCab92jZAHfZoAfa1eK7f9+ebEYM8CqTt3W
         7km0dsRL45tuvuZ0tg+qAmUxpwH6rMNWNneJolGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gaurav Agrawal <agrawalgaurav@gnome.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 02/66] Input: synaptics - enable SMBus on ThinkPad L470
Date:   Tue, 18 Feb 2020 20:54:29 +0100
Message-Id: <20200218190428.289430191@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaurav Agrawal <agrawalgaurav@gnome.org>

commit b8a3d819f872e0a3a0a6db0dbbcd48071042fb98 upstream.

Add touchpad LEN2044 to the list, as it is capable of working with
psmouse.synaptics_intertouch=1

Signed-off-by: Gaurav Agrawal <agrawalgaurav@gnome.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/CADdtggVzVJq5gGNmFhKSz2MBwjTpdN5YVOdr4D3Hkkv=KZRc9g@mail.gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -180,6 +180,7 @@ static const char * const smbus_pnp_ids[
 	"LEN0097", /* X280 -> ALPS trackpoint */
 	"LEN009b", /* T580 */
 	"LEN200f", /* T450s */
+	"LEN2044", /* L470  */
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"SYN3052", /* HP EliteBook 840 G4 */


