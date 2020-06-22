Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F5320427E
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbgFVVSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:18:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45412 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbgFVVSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 17:18:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MLHxJv099025;
        Mon, 22 Jun 2020 21:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=8eTb3kygMQwdfnLH89m0ixFSqVZ28dH2AUlm3VuGUKg=;
 b=Xx7xSbcsqUc1NeGK8YHwoJ8pI8gukqRKxjgK/gD1li4dtVQvGJyWll4llANoXypmMtb/
 Ng1hIPH/tJJS3hGFOL0nMDBrANXggtPx8WibrfITMjNxoBmR4OHx7WrgXyka1ruhjz/z
 1WnSZ62pG/LM3NeI2ahHhbQpwM7Y1siuI5p3X1PqUY55gI5QZBAbNfNRzekKObh8/KXk
 w17++fwT6A7WjS6b/RQJiWw0mM2wGKSTI1jyA8njOzrd6QHsD5EEthDFj0jLQvsYFnNE
 6PWzwZzR664+sxSJEwhj+Qw9mqVPXUgZmifIhnFCDg6TPX675TIxavwHH2nmFDdSxeEE CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31sebb9rns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Jun 2020 21:17:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MLHw58045580;
        Mon, 22 Jun 2020 21:17:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31svc27xd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 21:17:58 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05MLHuNl011103;
        Mon, 22 Jun 2020 21:17:56 GMT
Received: from [192.168.1.25] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jun 2020 21:17:56 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2] scsi: qla2xxx: Keep initiator ports after RSCN
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200605144435.27023-1-r.bolshakov@yadro.com>
Date:   Mon, 22 Jun 2020 16:17:54 -0500
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        target-devel@vger.kernel.org, linux@yadro.com,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Martin Wilck <mwilck@suse.com>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <292EDF6F-222F-4180-AE16-5F9C8E83D317@oracle.com>
References: <20200605144435.27023-1-r.bolshakov@yadro.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006220138
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jun 5, 2020, at 9:44 AM, Roman Bolshakov <r.bolshakov@yadro.com> =
wrote:
>=20
> The driver performs SCR (state change registration) in all modes
> including pure target mode.
>=20
> For each RSCN, scan_needed flag is set in qla2x00_handle_rscn() for =
the
> port mentioned in the RSCN and fabric rescan is scheduled. During the
> rescan, GNN_FT handler, qla24xx_async_gnnft_done() deletes session of
> the port that caused the RSCN.
>=20
> In target mode, the session deletion has an impact on ATIO handler,
> qlt_24xx_atio_pkt(). Target responds with SAM STATUS BUSY to I/O
> incoming from the deleted session. qlt_handle_cmd_for_atio() and
> qlt_handle_task_mgmt() return -EFAULT if they are not able to find
> session of the command/TMF, and that results in invocation of
> qlt_send_busy():
>=20
>  qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0014
>  qla_target(0): Unable to send command to target, sending BUSY status
>=20
> Such response causes command timeout on the initiator. Error handler
> thread on the initiator will be spawned to abort the commands:
>=20
>  scsi 23:0:0:0: tag#0 abort scheduled
>  scsi 23:0:0:0: tag#0 aborting command
>  qla2xxx [0000:af:00.0]-188c:23: Entered qla24xx_abort_command.
>  qla2xxx [0000:af:00.0]-801c:23: Abort command issued nexus=3D23:0:0 =
-- 0 2003.
>=20
> Command abort is rejected by target and fails (2003), error handler =
then
> tries to perform DEVICE RESET and TARGET RESET but they're also doomed
> to fail because TMFs are ignored for the deleted sessions.
>=20
> Then initiator makes BUS RESET that resets the link via
> qla2x00_full_login_lip(). BUS RESET succeeds and brings initiator port
> up, SAN switch detects that and sends RSCN to the target port and it
> fails again the same way as described above. It never goes out of the
> loop.
>=20
> The change breaks the RSCN loop by keeping initiator sessions =
mentioned
> in RSCN payload in all modes, including dual and pure target mode.
>=20
> Fixes: 2037ce49d30a ("scsi: qla2xxx: Fix stale session")
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Arun Easi <aeasi@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
> drivers/scsi/qla2xxx/qla_gs.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> Changes since v1:
>  - Corrected an error when N_Port_ID change wouldn't clean up stale
>    session (Martin W.).
>=20
>    N_Port_ID may change in the switched fabric topology if initiator
>    cable is replugged to another physical port on the SAN switch (some
>    fabrics assign physical port number to domain area). Physical
>    reconnection implies that initiator is going to relogin anyway and
>    previous session is no longer needed.
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c =
b/drivers/scsi/qla2xxx/qla_gs.c
> index 42c3ad27f1cb..df670fba2ab8 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3496,7 +3496,9 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t =
*vha, srb_t *sp)
> 				qla2x00_clear_loop_id(fcport);
> 				fcport->flags |=3D FCF_FABRIC_DEVICE;
> 			} else if (fcport->d_id.b24 !=3D rp->id.b24 ||
> -				fcport->scan_needed) {
> +				   (fcport->scan_needed &&
> +				    fcport->port_type !=3D FCT_INITIATOR =
&&
> +				    fcport->port_type !=3D =
FCT_NVME_INITIATOR)) {
> 				qlt_schedule_sess_for_deletion(fcport);
> 			}
> 			fcport->d_id.b24 =3D rp->id.b24;
> --=20
> 2.26.1
>=20

Looks fine.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering





