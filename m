Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DB725FCA9
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 17:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgIGPJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 11:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730112AbgIGPDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 11:03:50 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB8BD215A4;
        Mon,  7 Sep 2020 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599491022;
        bh=1eaAwoqG6xM+mwzoFpFDJ8EaiOCIJ/KY/5TJzDrqrBY=;
        h=Date:From:To:To:To:CC:Cc:Subject:In-Reply-To:References:From;
        b=O8I0ZkJfaH4BpKNRSd64qSCbwO6u5LSeFAAA8DBr2zjKLEqV8af8E6sWSIH5u0cwn
         4ypvzWnF334eXJD/UrL6THCXjTjMji7aBv+HPKMD+EHYAejnY6E6akOtZhlbh8A6t0
         jvv+3zie/b4R0w0KC7YLyqtUG4HBMpQSdHM3OhL8=
Date:   Mon, 07 Sep 2020 15:03:41 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 04/12] evm: Execute evm_inode_init_security() only when the HMAC key is loaded
In-Reply-To: <20200904092339.19598-5-roberto.sassu@huawei.com>
References: <20200904092339.19598-5-roberto.sassu@huawei.com>
Message-Id: <20200907150341.DB8BD215A4@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 26ddabfe96bb ("evm: enable EVM when X509 certificate is loaded").

The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235.

v5.8.7: Build OK!
v5.4.63: Build OK!
v4.19.143: Build OK!
v4.14.196: Failed to apply! Possible dependencies:
    21af76631476 ("EVM: turn evm_config_xattrnames into a list")
    5feeb61183dd ("evm: Allow non-SHA1 digital signatures")
    650b29dbdf2c ("integrity: Introduce struct evm_xattr")
    ae1ba1676b88 ("EVM: Allow userland to permit modification of EVM-protected metadata")
    b33e3cc5c90b ("Merge branch 'next-integrity' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security")
    f00d79750712 ("EVM: Allow userspace to signal an RSA key has been loaded")

v4.9.235: Failed to apply! Possible dependencies:
    21af76631476 ("EVM: turn evm_config_xattrnames into a list")
    5feeb61183dd ("evm: Allow non-SHA1 digital signatures")
    650b29dbdf2c ("integrity: Introduce struct evm_xattr")
    ae1ba1676b88 ("EVM: Allow userland to permit modification of EVM-protected metadata")
    b33e3cc5c90b ("Merge branch 'next-integrity' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security")
    b4bfec7f4a86 ("security/integrity: Harden against malformed xattrs")
    f00d79750712 ("EVM: Allow userspace to signal an RSA key has been loaded")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
