Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B5B48F065
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 20:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiANTUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 14:20:12 -0500
Received: from mout.gmx.net ([212.227.15.19]:44441 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbiANTUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jan 2022 14:20:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1642188010;
        bh=AwJriVkhrEJyTWPEHF7U9Vw0OZgHXSeka+zk5yPYvNM=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=db5BJlmfmuXEGcT6zxM5351vU6bFOmN97h0eanhdOpsSZP0mpBmtc/5iZJuTfRSjO
         F29f1e90nfQ2mfSGW34tGEs5BlISG9sepc2ax037s6qDTi+J/flfiH0YHjwjBEQYYY
         YIIzd5zB3C5wmN30mNSzHAnaPgSEOhNgkrOAb2Kc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.32.222]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MplXz-1mXmVz2Vkj-00q8F2; Fri, 14
 Jan 2022 20:20:10 +0100
Message-ID: <58f0677b-4672-de44-06f6-09f74c285639@gmx.de>
Date:   Fri, 14 Jan 2022 20:20:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.16 00/37] 5.16.1-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:xE4+NT0Q3LI0j5XTfHb5YSedxEm27RAaDVLJSqvrZZ1bS841myx
 jIXZCzf6kEvp8Lo5LleC5SlndBvA5QbFYkMB6SEzsFROIFDrFkuPk/FS3JLrKfLR5/oJQo3
 HOHJ6YOvELpGZ6zw8vcXqE3dH/tICl68IXJS0sfjVKJ5nwpmQkszIcLDPWIvIhTkpEBN0v5
 4+MU9cPafwSEFA/R1iF0w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2xPWyRpC09Y=:RuUDKNLKW/O/8Qx5crDvED
 zIKqRuXnmV0xuibGsN55Bi7veJzAGlZd+TIrdLcORpo0UJtQdMcXhwGjxNshEEGRk1lt+6gdF
 PYU85mtNmu0vpw960AxtuvpSHVfMdPMArkjCAzISS882RaUDLNqdOycRXKIdV/zSTPw1rMHKS
 d4KQttOrpbejBxXe7dUvdyR+749eD2Pc+GymzXdZt9MXTsGyJkKAV5MET3q3vEdJp3fv0dl1q
 6ivjMmR8SWK1rVqBqnjUTn7QjK6ibAuPrVJZL+wrJ0h0owTejmB+qvJ0MScmPzn1NYur6ECa4
 vIOepvWpZ/FIPuFGg+qOptySFYyXy8AaA0b6WaUtLO3SalHoCVRvddBdrFopVjT4Fc9n5ZEMv
 zR24joeKXhNLjVuYmgp2PkHEmX5R5Q1JVrBTcuPUU3cKK9+xhzq3aoYwKbYXwZ5jTdfV+Smdz
 Vrvjla3bptyDjRoAsRklNNhva5DUHIrpsaW8SGqbjCNikgDKlpYBaQI5xbTuTk4QufD4s6ArG
 8QlV2tblKhsJVYV9D3Pagsl5JFAgIcamfKNSab6bpEY6CPfBCkJc397B5sX6pFohHUwrGB4HY
 3KNkCSoUJKzE00vwX6vt8qrTcdbDlbxxDhWMahBZCoMu9UHBJlMMSHHsHczeKZOq0GWnO9CU0
 wYUJE9tVzn26SO87k4LZQUkFhXPn2XkVsksFpy7HH4d2AOelkTwEpiNe+YnrdyxYGm8k/iaJj
 t2sOKQOb5DH2SpmCw8rPAbFqArMDqw6h80sg4hlQxXIIdUjMTfdQTUWylX6tL8zhwalcVLGIQ
 uXrXIajXZVKCZPuf+b/R1GvZ5GUNA/7C6raBGaiXUL5PElsPZaw/mHxS3k3Jhv9+KhuVvLpGM
 edPnfkvLWkbnvQZRxqd416bb+FRv61josMs4U8vs6bhlvJLDaxB1sVWbTR0auS1nAQUGt6eQj
 kF0FlRRdEa+OBUhbLKylhiqmAt5oIXZbD9Qwabth5qd/dujNJ3/FY66Bnmc690UR8pdZlbWJp
 aq3EmcZtwlXnfC80MLPwmIif1dxkNd25xPFQJBHkRl1UF8ZmTKtTD5BCUdWC1QUTbqSTS43Rw
 hw06Pm5k7Nkok4=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.1-rc1  successfully compiled, booted and suspended on an x86_64
(Intel i5-11400, Fedora 35)

Tested-by: Ronald Warsow <rwarsow@gmx.de>


Thanks

Ronald

