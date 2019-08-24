Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C961F9BEB6
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 18:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfHXQNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 12:13:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfHXQNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 12:13:10 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2A4221670
        for <stable@vger.kernel.org>; Sat, 24 Aug 2019 16:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566663189;
        bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=; h=From:Date:From;
        b=tCCLhrNjQYkdjBC5+WBw2b3eQPsXdPH+NbBP6THm/rKA6yX0ww7P5BZusvUdCc9j7
         boNN4gGhrzGhNs5zbMbXzjR5fY7Mv7Gs4TP7I8tji/KMPdCFD856l0wOrFX27cRVei
         jCGl5ppp0xacbLkvk36LU0yMQQXHLLAijPi67J5E=
From:   Sasha Levin <sashal@kernel.org>
Date:   Sat, 24 Aug 2019 16:13:08 +0000
Message-Id: <20190824161309.A2A4221670@mail.kernel.org>
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

