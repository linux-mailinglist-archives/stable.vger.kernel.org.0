Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A771D7B4C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 16:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgEROc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 10:32:28 -0400
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:61349 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgEROc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 10:32:28 -0400
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Sergei Trofimovich <slyfox@gentoo.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Masahiro Yamada <masahiroy@kernel.org>
From:   Thomas Backlund <tmb@mageia.org>
Subject: another gcc-10 fix for stable kernels
Message-ID: <a22fabc5-22d6-8278-34a8-f93f2412ba0d@mageia.org>
Date:   Mon, 18 May 2020 17:32:25 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

this one should be added to -stable trees too:

commit b1112139a103b4b1101d0d2d72931f2d33d8c978
Author: Sergei Trofimovich <slyfox@gentoo.org>
Date:   Tue Mar 17 00:07:18 2020 +0000

     Makefile: disallow data races on gcc-10 as well

--
Thomas
