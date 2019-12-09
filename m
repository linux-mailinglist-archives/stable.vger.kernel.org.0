Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287CD1170E3
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 16:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfLIPxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 10:53:46 -0500
Received: from mail-pg1-f179.google.com ([209.85.215.179]:40488 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfLIPxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 10:53:45 -0500
Received: by mail-pg1-f179.google.com with SMTP id k25so7320668pgt.7
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 07:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=O+rZ9+8sChTGUIad9SA96LAjyweFy1jeRgbI8aZttis=;
        b=lPHQSmeFh0AQxTG4CfCA62GXYLYgABLL5QWnTk1G0QxUNLl1126lNBsNB0YnLnOi1e
         WiGYXTQdSxe4az9BB+AsjVRoOvRGNiacLCO36enW9cqM/efdxYhMCfDvU2R2ZRJKVuQp
         0noltlSSAPOnDcuLmr0Og6650zlx2+ZYztpx9gb8SMEdVIessnretqMdAlHFE6VRyqio
         riSm9SlRpfRnv1GhXr2dqlMNaXermqTKUkghCPv3vscrzEYduqIlxVlB+KAULZw9YR4j
         x0Ofr5pWi9Wsq8HsJ1oAzvVdt4mFZUElCb+68z2vrakVPary4ez4C503MS8sGyUPX4gF
         cYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=O+rZ9+8sChTGUIad9SA96LAjyweFy1jeRgbI8aZttis=;
        b=ANofvTDYWYf1vq4+41Q1mciscF56+Pn2U5xKhC2LeCc0JXhtKoUlF7WSsql9J54WUx
         wsaXMMId6LCF96+PF/LjvGcBTKhBTfoDOlWqaB0ZwIVJNbAb0OqDEbPUQiCdxFtzXxR3
         X3KsvHXEnTClafCx6x/rlvdnOPO06pQ2ryxMdakeb+zbpuLjPE/r6R2Sb7xrPQBSYRI1
         FpCwBuwm6gxA+gKk225kh2PEm9RlkCk/cywcZp7APttvcPT3qBfoRG0HdALSWotE7rCi
         oIqHsJq66T6WLvUZVvOaP/YIbfHVKGxGBeGD20v/oEJRFyND1g3uNxUpkUqPLgsD89JB
         /2Xg==
X-Gm-Message-State: APjAAAWEb9XhRxrxexjTLCECdj1mOBRZbZ4X8jF0NjV1tIAb7PmICHjv
        oYdVwCqw8c5YG0U+nqzamutHdiJD
X-Google-Smtp-Source: APXvYqx0mgXa/UhjOmjPVX4j0bQ4hyUdjuZwJXFE1eXC/gkoC3rbdxGb9WLMw2pLlK9BFg7MWQ+WAw==
X-Received: by 2002:a63:551a:: with SMTP id j26mr19159095pgb.370.1575906824709;
        Mon, 09 Dec 2019 07:53:44 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g26sm26847857pfo.128.2019.12.09.07.53.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Dec 2019 07:53:44 -0800 (PST)
Date:   Mon, 9 Dec 2019 07:53:42 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Subject: stable release candidate build/test status
Message-ID: <20191209155342.GA30203@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

stable release candidates are a mess right now. Example build/boot
test results from 4.4.y.queue:

Build results:
	total: 170 pass: 163 fail: 7
Failed builds:
	arm:allmodconfig
	arm:u8500_defconfig
	arm:axm55xx_defconfig
	arm:mxs_defconfig
	arm:nhk8815_defconfig
	arm64:defconfig
	arm64:allmodconfig
Qemu test results:
	total: 325 pass: 261 fail: 64
Failed tests:
	<too many to list>

Most other branches are just as bad, and it isn't always just arm/arm64.
Is there a need to report details, or will it all be taken care of before
the next set of RCs ?

Thanks,
Guenter
