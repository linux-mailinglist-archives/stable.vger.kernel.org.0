Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F937159FA0
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 04:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgBLDoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Feb 2020 22:44:22 -0500
Received: from ozlabs.org ([203.11.71.1]:49227 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgBLDoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Feb 2020 22:44:22 -0500
Received: from neuling.org (localhost [127.0.0.1])
        by ozlabs.org (Postfix) with ESMTP id 48HQVq2L1kz9s29;
        Wed, 12 Feb 2020 14:44:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=neuling.org;
        s=201811; t=1581479059;
        bh=vHvxgr9Mi4kVU4CP+DLd8jLZICVO9UpdLx4IRY8/qAc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TFl8ycTowgf15CJA30P9wKR0Qk6bpdlEFhoGn9MjMkQU7T5LYHPkWySg+SlXE12X3
         fCQ8pfyWR+gG9m4Uy4Y4i4EKfy/CVMLaLn9jxyAgyKMetLmhUwlY4HdmQzYTCRzrtM
         xuchTnNhSJAPanXtVv1RgVhjOxKX2UQNMLabej6VAK/a4BGMQjy9/apaPx0XwaveHW
         OVB6OMj6MrpYDq0th8hozc5uL6zdrEhHqkWj3SGYC/siPo6uQHt73MusUoX2wPc1dE
         UMjwTYu1mguWl2kJuI7Fs6+VBsC3vgsSIPk5De0QISt60MKI28PucWHANsN5APwwJ/
         6ikU8sJMHnonQ==
Received: by neuling.org (Postfix, from userid 1000)
        id B4D462C1FF6; Wed, 12 Feb 2020 14:44:18 +1100 (AEDT)
Message-ID: <c88cd4e86f3d1874c277b5052e030625dd373f90.camel@neuling.org>
Subject: Re: [PATCH v3 1/3] powerpc/tm: Fix clearing MSR[TS] in current when
 reclaiming on signal delivery
From:   Michael Neuling <mikey@neuling.org>
To:     Gustavo Luiz Duarte <gustavold@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     stable@vger.kernel.org, gromero@linux.ibm.com
Date:   Wed, 12 Feb 2020 14:44:18 +1100
In-Reply-To: <20200211033831.11165-1-gustavold@linux.ibm.com>
References: <20200211033831.11165-1-gustavold@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Found with tm-signal-context-force-tm kernel selftest.
>=20
> v3: Subject and comment improvements.
> v2: Fix build failure when tm is disabled.
>=20
> Fixes: 2b0a576d15e0 ("powerpc: Add new transactional memory state to the
> signal context")
> Cc: stable@vger.kernel.org # v3.9
> Signed-off-by: Gustavo Luiz Duarte <gustavold@linux.ibm.com>

Acked-By: Michael Neuling <mikey@neuling.org>
