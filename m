Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0B33005F1
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbhAVOsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:48:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbhAVOY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2B8323A77;
        Fri, 22 Jan 2021 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325142;
        bh=4QU0QYJKASwhpGRzYAgrQ4RqEpVWwT2xa0k5nBxOIJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjHVHWieZnFC4B5Ai8uewof9siflGn30Khni2tSP5o71DCobxsrWPra2bd+S+c0Nb
         gjSReS1TANCvpGxhbHGi1o+5+m5sf8iRzu0ANT5C4VBpHPOcqlFDCzQ2GoL9u2g9Tw
         uC2HnElKfgoI8VB8bdOBMxtCGrHa+wjRSo9qbyxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 31/43] dt-bindings: net: renesas,etheravb: RZ/G2H needs tx-internal-delay-ps
Date:   Fri, 22 Jan 2021 15:12:47 +0100
Message-Id: <20210122135736.917516580@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f97844f9c518172f813b7ece18a9956b1f70c1bb ]

The merge resolution of the interaction of commits 307eea32b202864c
("dt-bindings: net: renesas,ravb: Add support for r8a774e1 SoC") and
d7adf6331189cbe9 ("dt-bindings: net: renesas,etheravb: Convert to
json-schema") missed that "tx-internal-delay-ps" should be a required
property on RZ/G2H.

Fixes: 8b0308fe319b8002 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20210105151516.1540653-1-geert+renesas@glider.be
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/renesas,etheravb.yaml |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -163,6 +163,7 @@ allOf:
             enum:
               - renesas,etheravb-r8a774a1
               - renesas,etheravb-r8a774b1
+              - renesas,etheravb-r8a774e1
               - renesas,etheravb-r8a7795
               - renesas,etheravb-r8a7796
               - renesas,etheravb-r8a77961


