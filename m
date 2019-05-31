Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6780630CEB
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 12:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEaK4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 06:56:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfEaK4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 06:56:45 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9AD5030C0DE1;
        Fri, 31 May 2019 10:56:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-173.rdu2.redhat.com [10.10.120.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACDBF63C31;
        Fri, 31 May 2019 10:56:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <155930001303.17253.2447519598157285098.stgit@warthog.procyon.org.uk>
References: <155930001303.17253.2447519598157285098.stgit@warthog.procyon.org.uk>
To:     viro@zeniv.linux.org.uk
Cc:     dhowells@redhat.com, stable@vger.kernel.org,
        Jose Bollo <jose.bollo@iot.bzh>,
        Casey Schaufler <casey@schaufler-ca.com>, jmorris@namei.org,
        torvalds@linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smack: Restore the smackfsdef mount option and add missing prefixes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17466.1559300202.1@warthog.procyon.org.uk>
Date:   Fri, 31 May 2019 11:56:42 +0100
Message-ID: <17467.1559300202@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 31 May 2019 10:56:45 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Should this go via Al's tree, James's tree, Casey's tree or directly to Linus?

David
