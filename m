Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636633E8219
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbhHJSFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238138AbhHJSDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:03:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A45E961409;
        Tue, 10 Aug 2021 17:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617680;
        bh=h9UURt33nYQLHYkLXmZGn7QmeUsikQkUcZQw1eJjg1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PY+vh2/mESAnF3TcOVsH3SSP4I6+8vzgTKKPnaQF/Dz9gJzgcGm/XMvVHiatW1yTa
         hfQBlLFtNCalTJP7dxbiuX6z/6hpmpkbxoGJJwl48YAkBHfWErYlPF4eYaKif9r5V8
         /umoUJH7nVV+tZ0P/FqZJuBumf7y36QlfvJgBFKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiu Wenbo <qiuwenbo@kylinos.com.cn>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.13 164/175] riscv: dts: fix memory size for the SiFive HiFive Unmatched
Date:   Tue, 10 Aug 2021 19:31:12 +0200
Message-Id: <20210810173006.359492229@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiu Wenbo <qiuwenbo@kylinos.com.cn>

commit d09560435cb712c9ec1e62b8a43a79b0af69fe77 upstream.

The production version of HiFive Unmatched have 16GB memory.

Signed-off-by: Qiu Wenbo <qiuwenbo@kylinos.com.cn>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
@@ -24,7 +24,7 @@
 
 	memory@80000000 {
 		device_type = "memory";
-		reg = <0x0 0x80000000 0x2 0x00000000>;
+		reg = <0x0 0x80000000 0x4 0x00000000>;
 	};
 
 	soc {


